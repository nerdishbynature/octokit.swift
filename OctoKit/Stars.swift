import Foundation
import RequestKit

public extension Octokit {

    /**
        Fetches all the starred repositories for a user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter name: The user who starred repositories.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func stars(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.readStars(name, configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let repos = repos {
                    completion(Response.success(repos))
                }
            }
        }
    }

    /**
        Fetches all the starred repositories for the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myStars(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.readAuthenticatedStars(configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let repos = repos {
                    completion(Response.success(repos))
                }
            }
        }
    }
}

enum StarsRouter: Router {
    case readAuthenticatedStars(Configuration)
    case readStars(String, Configuration)
    var method: HTTPMethod {
        return .GET
    }

    var configuration: Configuration {
        switch self {
        case .readAuthenticatedStars(let config): return config
        case .readStars(_, let config): return config
        }
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var path: String {
        switch self {
        case .readAuthenticatedStars:
            return "user/starred"
        case .readStars(let username, _):
            return "users/\(username)/starred"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
