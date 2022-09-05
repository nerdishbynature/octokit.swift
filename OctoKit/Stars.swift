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
     Checks if a repository is starred by the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func star(_ session: RequestKitURLSession = URLSession.shared,
              owner: String,
              repository: String,
              completion: @escaping (_ response: Result<Bool, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.readStar(configuration, owner, repository)
        return router.load(session) { error in
            guard let error = error else {
                completion(.success(true))
                return
            }
            if (error as NSError).code == 404 {
                completion(.success(false))
                return
            }
            completion(.failure(error))
        }
    }

    /**
     Stars a repository for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func putStar(_ session: RequestKitURLSession = URLSession.shared,
                 owner: String,
                 repository: String,
                 completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.putStar(configuration, owner, repository)
        return router.load(session, completion: completion)
    }

    /**
     Unstars a repository for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func deleteStar(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String,
                    completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StarsRouter.deleteStar(configuration, owner, repository)
        return router.load(session, completion: completion)
    }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension Octokit {
    /**
     Fetches all the starred repositories for a user
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter name: The user who starred repositories.
     */
    func stars(_ session: RequestKitURLSession = URLSession.shared, name: String) async throws -> [Repository] {
        let router = StarsRouter.readStars(name, configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self)
    }

    /**
     Fetches all the starred repositories for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - Returns: The repos which the authenticated user stars.
     */
    func myStars(_ session: RequestKitURLSession = URLSession.shared) async throws -> [Repository] {
        let router = StarsRouter.readAuthenticatedStars(configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self)
    }

    /**
     Checks if a repository is starred by the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - Returns: If the repository is starred by the authenticated user
     */
    func star(_ session: RequestKitURLSession = URLSession.shared,
              owner: String,
              repository: String) async throws -> Bool {
        let router = StarsRouter.readStar(configuration, owner, repository)
        do {
            try await router.load(session)
            return true
        } catch let error as NSError where error.code == 404 {
            return false
        } catch {
            throw error
        }
    }

    /**
     Stars a repository for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     */
    func putStar(_ session: RequestKitURLSession = URLSession.shared,
                 owner: String,
                 repository: String) async throws {
        let router = StarsRouter.putStar(configuration, owner, repository)
        return try await router.load(session)
    }

    /**
     Unstars a repository for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     */
    func deleteStar(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String) async throws {
        let router = StarsRouter.deleteStar(configuration, owner, repository)
        return try await router.load(session)
    }
}
#endif

enum StarsRouter: Router {
    case readAuthenticatedStars(Configuration)
    case readStars(String, Configuration)
    case readStar(Configuration, String, String)
    case putStar(Configuration, String, String)
    case deleteStar(Configuration, String, String)

    var method: HTTPMethod {
        switch self {
        case .readAuthenticatedStars, .readStars, .readStar:
            return .GET
        case .putStar:
            return .PUT
        case .deleteStar:
            return .DELETE
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readAuthenticatedStars(config): return config
        case let .readStars(_, config): return config
        case let .readStar(config, _, _): return config
        case let .putStar(config, _, _): return config
        case let .deleteStar(config, _, _): return config
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
        case let .readStar(_, owner, repository):
            return "/user/starred/\(owner)/\(repository)"
        case let .putStar(_, owner, repository):
            return "/user/starred/\(owner)/\(repository)"
        case let .deleteStar(_, owner, repository):
            return "/user/starred/\(owner)/\(repository)"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
