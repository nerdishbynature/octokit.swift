import Foundation
import RequestKit

// MARK: model

@objc open class Repository: NSObject {
    open let id: Int
    open let owner: User
    open var name: String?
    open var fullName: String?
    open var isPrivate: Bool
    open var repositoryDescription: String?
    open var isFork: Bool?
    open var gitURL: String?
    open var sshURL: String?
    open var cloneURL: String?
    open var htmlURL: String?
    open var size: Int
    open var lastPush: Date?

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            fullName = json["full_name"] as? String
            isPrivate = json["private"] as? Bool ?? false
            repositoryDescription = json["description"] as? String
            isFork = json["fork"] as? Bool
            gitURL = json["git_url"] as? String
            sshURL = json["ssh_url"] as? String
            cloneURL = json["clone_url"] as? String
            htmlURL = json["html_url"] as? String
            size = json["size"] as? Int ?? 0
            lastPush = Time.rfc3339Date(json["pushed_at"] as? String)
        } else {
            id = -1
            isPrivate = false
            size = 0
        }
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
    public func repositories(_ session: RequestKitURLSession = URLSession.shared, owner: String? = nil, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Repository]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = (owner != nil)
            ? RepositoryRouter.readRepositories(configuration, owner!, page, perPage)
            : RepositoryRouter.readAuthenticatedRepositories(configuration, page, perPage)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let repos = json.map { Repository($0) }
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
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let repo = Repository(json)
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
