import Foundation
import RequestKit

// MARK: model
#if os(Linux)
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
    }
}
#else
@objc open class Repository: NSObject, Codable {
    @objc open private(set) var id: Int = -1
    @objc open private(set) var owner = User()
    @objc open var name: String?
    @objc open var fullName: String?
    @objc open private(set) var isPrivate: Bool = false
    @objc open var repositoryDescription: String?
    @objc open private(set) var isFork: Bool = false
    @objc open var gitURL: String?
    @objc open var sshURL: String?
    @objc open var cloneURL: String?
    @objc open var htmlURL: String?
    @objc open private(set) var size: Int = -1
    @objc open var lastPush: Date?

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
    }
}
#endif

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
    public func repositories(_ session: RequestKitURLSession = URLSession.shared, owner: String? = nil, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = (owner != nil)
            ? RepositoryRouter.readRepositories(configuration, owner!, page, perPage)
            : RepositoryRouter.readAuthenticatedRepositories(configuration, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Repository].self) { repos, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let repos = repos {
                completion(Response.success(repos))
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
    public func repository(_ session: RequestKitURLSession = URLSession.shared, owner: String, name: String, completion: @escaping (_ response: Response<Repository>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = RepositoryRouter.readRepository(configuration, owner, name)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Repository.self) { repo, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let repo = repo {
                    completion(Response.success(repo))
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
        case .readRepositories(let config, _, _, _): return config
        case .readAuthenticatedRepositories(let config, _, _): return config
        case .readRepository(let config, _, _): return config
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
        case .readRepositories(_, _, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .readAuthenticatedRepositories(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .readRepository:
            return [:]
        }
    }

    var path: String {
        switch self {
        case .readRepositories(_, let owner, _, _):
            return "users/\(owner)/repos"
        case .readAuthenticatedRepositories:
            return "user/repos"
        case .readRepository(_, let owner, let name):
            return "repos/\(owner)/\(name)"
        }
    }
}
