import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension Octokit {
    /**
         Fetches all the starred repositories for a user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter name: The user who starred repositories.
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func stars(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Result<[Repository], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.readStars(name, configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let repos = repos {
                    completion(.success(repos))
                }
            }
        }
    }

    /**
         Fetches all the starred repositories for the authenticated user
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myStars(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Result<[Repository], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.readAuthenticatedStars(configuration)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let repos = repos {
                    completion(.success(repos))
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
        case let .readAuthenticatedStars(config): return config
        case let .readStars(_, config): return config
        }
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var path: String {
        switch self {
        case .readAuthenticatedStars:
            return "user/starred"
        case let .readStars(username, _):
            return "users/\(username)/starred"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
