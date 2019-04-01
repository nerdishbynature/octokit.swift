import Foundation
import RequestKit

// MARK: model

open class Gist: Codable {
    open private(set) var id: String?
    open var url: URL?
    open var forksURL: URL?
    open var commitsURL: URL?
    open var gitPushURL: URL?
    open var gitPullURL: URL?
    open var commentsURL: URL?
    open var htmlURL: URL?
    open var files: Files
    open var publicGist: Bool?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var description: String?
    open var comments: Int?
    open var user: User?
    open var owner: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case gitPushURL = "git_pull_url"
        case gitPullURL = "git_push_url"
        case commentsURL = "comments_url"
        case htmlURL = "html_url"
        case files
        case publicGist = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case comments
        case user
        case owner
    }
}

// MARK: request

public extension Octokit {
    
    /**
     Fetches the gists of the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myGists(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Gist]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readAuthenticatedGists(configuration, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self) { gists, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let gists = gists {
                    completion(Response.success(gists))
                }
            }
        }
    }
    
    /**
     Fetches the gists of the specified user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The username who owns the gists.
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gists(_ session: RequestKitURLSession = URLSession.shared, owner: String, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Gist]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readGists(configuration, owner, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self) { gists, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let gists = gists {
                    completion(Response.success(gists))
                }
            }
        }
    }
    
    /**
     Fetches an gist in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter id: The id of the gist.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gist(_ session: RequestKitURLSession = URLSession.shared, id: String, completion: @escaping (_ response: Response<Gist>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readGist(configuration, id)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let gist = gist {
                    completion(Response.success(gist))
                }
            }
        }
    }
    
    /**
     Creates an gist with a single file.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter completion: Callback for the issue that is created.
     */
    @discardableResult
    func postGistFile(_ session: RequestKitURLSession = URLSession.shared, description: String, filename: String, fileContent: String, completion: @escaping (_ response: Response<Gist>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.postGistFile(configuration, description, filename, fileContent)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let gist = gist {
                    completion(Response.success(gist))
                }
            }
        }
    }
    
    /**
     Edits an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter state: Whether the issue is open or closed.
     - parameter completion: Callback for the issue that is created.
     */
    @discardableResult
    func patchGistFile(_ session: RequestKitURLSession = URLSession.shared, id: String, description: String, filename: String, fileContent: String, completion: @escaping (_ response: Response<Gist>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.patchGistFile(configuration, id, description, filename, fileContent)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let gist = gist {
                    completion(Response.success(gist))
                }
            }
        }
    }
}

// MARK: Router

enum GistRouter: JSONPostRouter {
    case readAuthenticatedGists(Configuration, String, String)
    case readGists(Configuration, String, String, String)
    case readGist(Configuration, String)
    case postGistFile(Configuration, String, String, String)
    case patchGistFile(Configuration, String, String, String, String)
    
    var method: HTTPMethod {
        switch self {
        case .postGistFile, .patchGistFile:
            return .POST
        default:
            return .GET
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        case .postGistFile, .patchGistFile:
            return .json
        default:
            return .url
        }
    }
    
    var configuration: Configuration {
        switch self {
        case .readAuthenticatedGists(let config, _, _): return config
        case .readGists(let config, _, _, _): return config
        case .readGist(let config, _): return config
        case .postGistFile(let config, _, _, _): return config
        case .patchGistFile(let config, _, _, _, _): return config
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .readAuthenticatedGists(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .readGists(_, _, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .readGist:
            return [:]
        case .postGistFile(_, let description, let filename, let fileContent):
            var params = [String: Any]()
            params["description"] = description
            var file = [String: Any]()
            file["content"] = fileContent
            var files = [String: Any]()
            files[filename] = file
            params["files"] = files
            return params
        case .patchGistFile(_, _, let description, let filename, let fileContent):
            var params = [String: Any]()
            params["description"] = description
            var file = [String: Any]()
            file["content"] = fileContent
            var files = [String: Any]()
            files[filename] = file
            params["files"] = files
            return params
        }
    }
    
    var path: String {
        switch self {
        case .readAuthenticatedGists(_, _, _):
            return "/gists"
        case .readGists(_, let owner, _, _):
            return "users/\(owner)/gists"
        case .readGist(_, let id):
            return "gists/\(id)"
        case .postGistFile(_, _, _, _):
            return "gists"
        case .patchGistFile(_, let id, _, _, _):
            return "gists/\(id)"
        }
    }
    
}
