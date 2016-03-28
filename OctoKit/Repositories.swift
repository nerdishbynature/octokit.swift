import Foundation
import RequestKit

// MARK: model

@objc public class Repository: NSObject {
    public let id: Int
    public let owner: User
    public var name: String?
    public var fullName: String?
    public var isPrivate: Bool
    public var repositoryDescription: String?
    public var isFork: Bool?
    public var gitURL: String?
    public var sshURL: String?
    public var cloneURL: String?
    public var htmlURL: String?
    public var size: Int
    public var lastPush: NSDate?

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
        - parameter owner: The user or organization that owns the repositories. If `nil`, fetches repositories for the authenticated user.
        - parameter page: Current page for repository pagination. `1` by default.
        - parameter perPage: Number of repositories per page. `100` by default.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func repositories(owner: String? = nil, page: String = "1", perPage: String = "100", completion: (response: Response<[Repository]>) -> Void) {
        let router = (owner != nil)
            ? RepositoryRouter.ReadRepositories(configuration, owner!, page, perPage)
            : RepositoryRouter.ReadAuthenticatedRepositories(configuration, page, perPage)
        router.loadJSON(expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let repos = json.map { Repository($0) }
                completion(response: Response.Success(repos))
            }
        }
    }

    /**
        Fetches a repository for a user or organization
        - parameter owner: The user or organization that owns the repositories.
        - parameter name: The name of the repository to fetch.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func repository(owner: String, name: String, completion: (response: Response<Repository>) -> Void) {
        let router = RepositoryRouter.ReadRepository(configuration, owner, name)
        router.loadJSON(expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let repo = Repository(json)
                    completion(response: Response.Success(repo))
                }
            }
        }
    }
}

// MARK: Router

enum RepositoryRouter: Router {
    case ReadRepositories(Configuration, String, String, String)
    case ReadAuthenticatedRepositories(Configuration, String, String)
    case ReadRepository(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadRepositories(let config, _, _, _): return config
        case .ReadAuthenticatedRepositories(let config, _, _): return config
        case .ReadRepository(let config, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var params: [String: String] {
        switch self {
        case .ReadRepositories(_, _, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .ReadAuthenticatedRepositories(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .ReadRepository:
            return [:]
        }
    }

    var path: String {
        switch self {
        case ReadRepositories(_, let owner, _, _):
            return "/users/\(owner)/repos"
        case .ReadAuthenticatedRepositories:
            return "/user/repos"
        case .ReadRepository(_, let owner, let name):
            return "/repos/\(owner)/\(name)"
        }
    }
}
