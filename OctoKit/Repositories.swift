import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model

open class Repository: Codable {
    open private(set) var id: Int = -1
    open private(set) var owner = User()
    open var name: String?
    open var fullName: String?
    open private(set) var isPrivate: Bool = false
    open var repositoryDescription: String?
    open private(set) var isFork: Bool = false
    open var gitURL: String?
    open var sshURL: String?
    open var cloneURL: String?
    open var htmlURL: String?
    open private(set) var size: Int = -1
    open var lastPush: Date?
    open var stargazersCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case repositoryDescription = "description"
        case isFork = "fork"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case htmlURL = "html_url"
        case size
        case lastPush = "pushed_at"
        case stargazersCount = "stargazers_count"
    }
}

// MARK: request

public extension Octokit {
    /**
         Fetches the Repositories for a user or organization
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter owner: The user or organization that owns the repositories. If `nil`, fetches repositories for the authenticated user.
         - parameter page: Current page for repository pagination. `1` by default.
         - parameter perPage: Number of repositories per page. `100` by default.
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func repositories(_ session: RequestKitURLSession = URLSession.shared,
                      owner: String? = nil,
                      page: String = "1",
                      perPage: String = "100",
                      completion: @escaping (_ response: Result<[Repository], Error>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = (owner != nil)
            ? RepositoryRouter.readRepositories(configuration, owner!, page, perPage)
            : RepositoryRouter.readAuthenticatedRepositories(configuration, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(.failure(error))
            }

            if let repos = repos {
                completion(.success(repos))
            }
        }
    }

    /**
         Fetches a repository for a user or organization
         - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
         - parameter owner: The user or organization that owns the repositories.
         - parameter name: The name of the repository to fetch.
         - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func repository(_ session: RequestKitURLSession = URLSession.shared, owner: String, name: String,
                    completion: @escaping (_ response: Result<Repository, Error>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = RepositoryRouter.readRepository(configuration, owner, name)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Repository.self) { repo, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let repo = repo {
                    completion(.success(repo))
                }
            }
        }
    }
}

// MARK: Router

enum RepositoryRouter: Router {
    case readRepositories(Configuration, String, String, String)
    case readAuthenticatedRepositories(Configuration, String, String)
    case readRepository(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case let .readRepositories(config, _, _, _): return config
        case let .readAuthenticatedRepositories(config, _, _): return config
        case let .readRepository(config, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
        case let .readRepositories(_, _, page, perPage):
            return ["per_page": perPage, "page": page]
        case let .readAuthenticatedRepositories(_, page, perPage):
            return ["per_page": perPage, "page": page]
        case .readRepository:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .readRepositories(_, owner, _, _):
            return "users/\(owner)/repos"
        case .readAuthenticatedRepositories:
            return "user/repos"
        case let .readRepository(_, owner, name):
            return "repos/\(owner)/\(name)"
        }
    }
}
