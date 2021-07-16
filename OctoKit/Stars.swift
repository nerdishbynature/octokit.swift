import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension Octokit {

    /**
        Fetches all the starred repositories for a user
        - parameter session: RequestKitURLSession, defaults to URLSession.shared
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
        Fetches all the starred repositories for a user
        - parameter session: RequestKitURLSession, defaults to URLSession.shared
        - parameter name: The user who starred repositories.
    */
    #if !canImport(FoundationNetworking) && !os(macOS)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func stars(_ session: RequestKitURLSession = URLSession.shared, name: String) async throws -> [Repository] {
        let router = StarsRouter.readStars(name, configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self)
    }
    #endif

    /**
        Fetches all the starred repositories for the authenticated user
        - parameter session: RequestKitURLSession, defaults to URLSession.shared
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

    /**
        Fetches all the starred repositories for the authenticated user
        - parameter session: RequestKitURLSession, defaults to URLSession.shared
        - parameter completion: Callback for the outcome of the fetch.
    */
    #if !canImport(FoundationNetworking) && !os(macOS)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func myStars(_ session: RequestKitURLSession = URLSession.shared) async throws -> [Repository] {
        let router = StarsRouter.readAuthenticatedStars(configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self)
    }
    #endif
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
