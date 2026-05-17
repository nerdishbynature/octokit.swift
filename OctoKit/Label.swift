import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class Label: Codable {
    open var url: URL?
    open var name: String?
    open var color: String?

    public init(url: URL? = nil,
                name: String? = nil,
                color: String? = nil) {
        self.url = url
        self.name = name
        self.color = color
    }
}

// MARK: request

public extension Octokit {
    /**
      Fetches a single label in a repository
      - parameter owner: The user or organization that owns the repository.
      - parameter repository: The name of the repository.
      - parameter name: The name of the label.
      - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func label(owner: String,
               repository: String,
               name: String,
               completion: @escaping (_ response: Result<Label, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.readLabel(configuration, owner, repository, name)
        return router.load(session, decoder: configuration.decoder, expectedResultType: Label.self) { label, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let label = label {
                    completion(.success(label))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
      Fetches a single label in a repository
      - parameter owner: The user or organization that owns the repository.
      - parameter repository: The name of the repository.
      - parameter name: The name of the label.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func label(owner: String, repository: String, name: String) async throws -> Label {
        let router = LabelRouter.readLabel(configuration, owner, repository, name)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: Label.self)
    }
    #endif

    /**
     Fetches all labels in a repository
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func labels(owner: String,
                repository: String,
                page: String = "1",
                perPage: String = "100",
                completion: @escaping (_ response: Result<[Label], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return router.load(session, decoder: configuration.decoder, expectedResultType: [Label].self) { labels, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let labels = labels {
                    completion(.success(labels))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches all labels in a repository
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func labels(owner: String, repository: String, page: String = "1", perPage: String = "100") async throws -> [Label] {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }
    #endif

    @discardableResult
    func labelsPaginated(owner: String,
                         repository: String,
                         page: String = "1",
                         perPage: String = "100",
                         completion: @escaping (_ response: Result<PaginatedResponse<[Label]>, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return router.loadPaginated(session, decoder: configuration.decoder, expectedResultType: [Label].self) { response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response {
                completion(.success(response))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func labelsPaginated(owner: String, repository: String, page: String = "1", perPage: String = "100") async throws -> PaginatedResponse<[Label]> {
        let router = LabelRouter.readLabels(configuration, owner, repository, page, perPage)
        return try await router.loadPaginated(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }
    #endif

    /**
     Create a label in a repository
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter name: The name of the label.
     - parameter color: The color of the label, in hexadecimal without the leading `#`.
     - parameter completion: Callback for the outcome of the request.
     */
    @discardableResult
    func postLabel(owner: String,
                   repository: String,
                   name: String,
                   color: String,
                   completion: @escaping (_ response: Result<Label, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.createLabel(configuration, owner, repository, name, color)
        return router.post(session, decoder: configuration.decoder, expectedResultType: Label.self) { label, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let label = label {
                    completion(.success(label))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Create a label in a repository
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter name: The name of the label.
     - parameter color: The color of the label, in hexadecimal without the leading `#`.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func postLabel(owner: String, repository: String, name: String, color: String) async throws -> Label {
        let router = LabelRouter.createLabel(configuration, owner, repository, name, color)
        return try await router.post(session, decoder: configuration.decoder, expectedResultType: Label.self)
    }
    #endif

    // MARK: - New async-only endpoints

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func updateLabel(owner: String,
                     repository: String,
                     name: String,
                     newName: String? = nil,
                     color: String? = nil,
                     labelDescription: String? = nil) async throws -> Label {
        let router = LabelRouter.updateLabel(configuration, owner, repository, name, newName, color, labelDescription)
        return try await router.post(session, decoder: configuration.decoder, expectedResultType: Label.self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func deleteLabel(owner: String, repository: String, name: String) async throws {
        let router = LabelRouter.deleteLabel(configuration, owner, repository, name)
        return try await router.delete(session)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issueLabels(owner: String, repository: String, number: Int) async throws -> [Label] {
        let router = LabelRouter.readIssueLabels(configuration, owner, repository, number)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func addLabelsToIssue(owner: String, repository: String, number: Int, labels: [String]) async throws -> [Label] {
        let router = LabelRouter.addLabelsToIssue(configuration, owner, repository, number, labels)
        return try await router.post(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func removeLabelFromIssue(owner: String, repository: String, number: Int, name: String) async throws -> [Label] {
        let router = LabelRouter.removeLabelFromIssue(configuration, owner, repository, number, name)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func replaceIssueLabels(owner: String, repository: String, number: Int, labels: [String]) async throws -> [Label] {
        let router = LabelRouter.replaceIssueLabels(configuration, owner, repository, number, labels)
        return try await router.post(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func removeAllIssueLabels(owner: String, repository: String, number: Int) async throws {
        let router = LabelRouter.removeAllIssueLabels(configuration, owner, repository, number)
        return try await router.delete(session)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func milestoneLabels(owner: String, repository: String, number: Int) async throws -> [Label] {
        let router = LabelRouter.readMilestoneLabels(configuration, owner, repository, number)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [Label].self)
    }
}

enum LabelRouter: JSONPostRouter {
    case readLabel(Configuration, String, String, String)
    case readLabels(Configuration, String, String, String, String)
    case createLabel(Configuration, String, String, String, String)
    case updateLabel(Configuration, String, String, String, String?, String?, String?)
    case deleteLabel(Configuration, String, String, String)
    case readIssueLabels(Configuration, String, String, Int)
    case addLabelsToIssue(Configuration, String, String, Int, [String])
    case removeLabelFromIssue(Configuration, String, String, Int, String)
    case replaceIssueLabels(Configuration, String, String, Int, [String])
    case removeAllIssueLabels(Configuration, String, String, Int)
    case readMilestoneLabels(Configuration, String, String, Int)

    var method: HTTPMethod {
        switch self {
        case .createLabel, .addLabelsToIssue, .replaceIssueLabels:
            return .POST
        case .updateLabel:
            return .PATCH
        case .deleteLabel, .removeLabelFromIssue, .removeAllIssueLabels:
            return .DELETE
        default:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .createLabel, .updateLabel, .addLabelsToIssue, .replaceIssueLabels:
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
        case let .updateLabel(config, _, _, _, _, _, _): return config
        case let .deleteLabel(config, _, _, _): return config
        case let .readIssueLabels(config, _, _, _): return config
        case let .addLabelsToIssue(config, _, _, _, _): return config
        case let .removeLabelFromIssue(config, _, _, _, _): return config
        case let .replaceIssueLabels(config, _, _, _, _): return config
        case let .removeAllIssueLabels(config, _, _, _): return config
        case let .readMilestoneLabels(config, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readLabel: return [:]
        case let .readLabels(_, _, _, page, perPage):
            return ["per_page": perPage, "page": page]
        case let .createLabel(_, _, _, name, color):
            return ["name": name, "color": color]
        case let .updateLabel(_, _, _, _, newName, color, description):
            var params: [String: String] = [:]
            if let newName = newName { params["new_name"] = newName }
            if let color = color { params["color"] = color }
            if let description = description { params["description"] = description }
            return params
        case .deleteLabel: return [:]
        case .readIssueLabels: return [:]
        case let .addLabelsToIssue(_, _, _, _, labels):
            return ["labels": labels]
        case .removeLabelFromIssue: return [:]
        case let .replaceIssueLabels(_, _, _, _, labels):
            return ["labels": labels]
        case .removeAllIssueLabels: return [:]
        case .readMilestoneLabels: return [:]
        }
    }

    var path: String {
        switch self {
        case let .readLabel(_, owner, repository, name):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "repos/\(owner)/\(repository)/labels/\(name)"
        case let .readLabels(_, owner, repository, _, _):
            return "repos/\(owner)/\(repository)/labels"
        case let .createLabel(_, owner, repository, _, _):
            return "repos/\(owner)/\(repository)/labels"
        case let .updateLabel(_, owner, repository, name, _, _, _):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "repos/\(owner)/\(repository)/labels/\(name)"
        case let .deleteLabel(_, owner, repository, name):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "repos/\(owner)/\(repository)/labels/\(name)"
        case let .readIssueLabels(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/issues/\(number)/labels"
        case let .addLabelsToIssue(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/labels"
        case let .removeLabelFromIssue(_, owner, repository, number, name):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "repos/\(owner)/\(repository)/issues/\(number)/labels/\(name)"
        case let .replaceIssueLabels(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/labels"
        case let .removeAllIssueLabels(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/issues/\(number)/labels"
        case let .readMilestoneLabels(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/milestones/\(number)/labels"
        }
    }
}
