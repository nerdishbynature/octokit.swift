import Foundation
import RequestKit

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
    func label(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, name: String, completion: @escaping (_ response: Response<Label>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = LabelRouter.readLabel(configuration, owner, repository, name)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Label.self) { label, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let label = label {
                    completion(Response.success(label))
                }
            }
        }
    }
}

enum LabelRouter: JSONPostRouter {
    case readLabel(Configuration, String, String, String)
    var method: HTTPMethod {
        switch self {
        default:
            return .GET
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        default:
            return .url
        }
    }
    
    var configuration: Configuration {
        switch self {
        case .readLabel(let config, _, _, _): return config
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .readLabel: return [:]
        }
    }
    
    var path: String {
        switch self {
        case .readLabel(_, let owner, let repository, let name):
            let name = name.stringByAddingPercentEncodingForRFC3986() ?? name
            return "/repos/\(owner)/\(repository)/labels/\(name)"
        }
    }
}
