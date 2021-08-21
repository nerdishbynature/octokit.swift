import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    func myGists(_ session: RequestKitURLSession = URLSession.shared, page: String = "1", perPage: String = "100",
                 completion: @escaping (_ response: Response<[Gist]>) -> Void) -> URLSessionDataTaskProtocol?
    {
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
    func gists(_ session: RequestKitURLSession = URLSession.shared, owner: String, page: String = "1", perPage: String = "100",
               completion: @escaping (_ response: Response<[Gist]>) -> Void) -> URLSessionDataTaskProtocol?
    {
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
     Fetches an gist
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
     - parameter publicAccess: The public/private visability of the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func postGistFile(_ session: RequestKitURLSession = URLSession.shared,
                      description: String,
                      filename: String,
                      fileContent: String,
                      publicAccess: Bool,
                      completion: @escaping (_ response: Response<Gist>) -> Void) -> URLSessionDataTaskProtocol?
    {
        let router = GistRouter.postGistFile(configuration, description, filename, fileContent, publicAccess)
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
     Edits an gist with a single file.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter id: The of the gist to update.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func patchGistFile(_ session: RequestKitURLSession = URLSession.shared,
                       id: String,
                       description: String,
                       filename: String,
                       fileContent: String,
                       completion: @escaping (_ response: Response<Gist>) -> Void) -> URLSessionDataTaskProtocol?
    {
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
    case postGistFile(Configuration, String, String, String, Bool)
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
        case let .readAuthenticatedGists(config, _, _): return config
        case let .readGists(config, _, _, _): return config
        case let .readGist(config, _): return config
        case let .postGistFile(config, _, _, _, _): return config
        case let .patchGistFile(config, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .readAuthenticatedGists(_, page, perPage):
            return ["per_page": perPage, "page": page]
        case let .readGists(_, _, page, perPage):
            return ["per_page": perPage, "page": page]
        case .readGist:
            return [:]
        case let .postGistFile(_, description, filename, fileContent, publicAccess):
            var params = [String: Any]()
            params["public"] = publicAccess
            params["description"] = description
            var file = [String: Any]()
            file["content"] = fileContent
            var files = [String: Any]()
            files[filename] = file
            params["files"] = files
            return params
        case let .patchGistFile(_, _, description, filename, fileContent):
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
        case .readAuthenticatedGists:
            return "gists"
        case let .readGists(_, owner, _, _):
            return "users/\(owner)/gists"
        case let .readGist(_, id):
            return "gists/\(id)"
        case .postGistFile:
            return "gists"
        case let .patchGistFile(_, id, _, _, _):
            return "gists/\(id)"
        }
    }
}
