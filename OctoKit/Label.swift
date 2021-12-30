import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class Label: Codable {
    open var url: URL?
    open var name: String?
    open var color: String?
}

// MARK: request

public extension Octokit {
    /**
      Fetches a single label in a repository
      - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
      - parameter owner: The user or organization that owns the repository.
      - parameter repository: The name of the repository.
      - parameter name: The name of the label.
      - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func label(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, name: String,
               completion: @escaping (_ response: Result<Label, Error>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = LabelRouter.readLabel(configuration, owner, repository, name)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Label.self) { label, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let label = label {
                    completion(.success(label))
                }
            }
        }
    }

    /**
     Fetches all labels in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func labels(_ session: RequestKitURLSession = URLSession.shared,
                owner: String,
                repository: String,
                page: String = "1",
                perPage: String = "100",
                completion: @escaping (_ response: Result<[Label], Error>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Label].self) { labels, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let labels = labels {
                    completion(.success(labels))
                }
            }
        }
    }

    /**
     Create a label in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter name: The name of the label.
     - parameter color: The color of the label, in hexadecimal without the leading `#`.
     - parameter completion: Callback for the outcome of the request.
     */
    @discardableResult
    func postLabel(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, name: String, color: String,
                   completion: @escaping (_ response: Result<Label, Error>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = LabelRouter.createLabel(configuration, owner, repository, name, color)
        return router.post(session, expectedResultType: Label.self) { label, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let label = label {
                    completion(.success(label))
                }
            }
        }
    }
}

enum LabelRouter: JSONPostRouter {
    case readLabel(Configuration, String, String, String)
    case readLabels(Configuration, String, String, String, String)
    case createLabel(Configuration, String, String, String, String)

    var method: HTTPMethod {
        switch self {
        case .createLabel:
            return .POST
        default:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .createLabel:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readLabel(config, _, _, _): return config
        case let .readLabels(config, _, _, _, _): return config
        case let .createLabel(config, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readLabel: return [:]
        case let .readLabels(_, _, _, page, perPage):
            return ["per_page": perPage, "page": page]
        case let .createLabel(_, _, _, name, color):
            return ["name": name, "color": color]
        }
    }

    var path: String {
        switch self {
        case let .readLabel(_, owner, repository, name):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "/repos/\(owner)/\(repository)/labels/\(name)"
        case let .readLabels(_, owner, repository, _, _):
            return "/repos/\(owner)/\(repository)/labels"
        case let .createLabel(_, owner, repository, _, _):
            return "/repos/\(owner)/\(repository)/labels"
        }
    }
}
