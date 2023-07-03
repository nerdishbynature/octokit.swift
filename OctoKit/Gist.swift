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

    public init(id: String? = nil,
                url: URL? = nil,
                forksURL: URL? = nil,
                commitsURL: URL? = nil,
                gitPushURL: URL? = nil,
                gitPullURL: URL? = nil,
                commentsURL: URL? = nil,
                htmlURL: URL? = nil,
                files: Files,
                publicGist: Bool? = nil,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                description: String? = nil,
                comments: Int? = nil,
                user: User? = nil,
                owner: User? = nil) {
        self.id = id
        self.url = url
        self.forksURL = forksURL
        self.commitsURL = commitsURL
        self.gitPushURL = gitPushURL
        self.gitPullURL = gitPullURL
        self.commentsURL = commentsURL
        self.htmlURL = htmlURL
        self.files = files
        self.publicGist = publicGist
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.description = description
        self.comments = comments
        self.user = user
        self.owner = owner
    }

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
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myGists(page: String = "1",
                 perPage: String = "100",
                 completion: @escaping (_ response: Result<[Gist], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readAuthenticatedGists(configuration, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self) { gists, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let gists = gists {
                    completion(.success(gists))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches the gists of the authenticated user
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func myGists(page: String = "1", perPage: String = "100") async throws -> [Gist] {
        let router = GistRouter.readAuthenticatedGists(configuration, page, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self)
    }
    #endif

    /**
     Fetches the gists of the specified user
     - parameter owner: The username who owns the gists.
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gists(owner: String,
               page: String = "1",
               perPage: String = "100",
               completion: @escaping (_ response: Result<[Gist], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readGists(configuration, owner, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self) { gists, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let gists = gists {
                    completion(.success(gists))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches the gists of the specified user
     - parameter owner: The username who owns the gists.
     - parameter page: Current page for gist pagination. `1` by default.
     - parameter perPage: Number of gists per page. `100` by default.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func gists(owner: String, page: String = "1", perPage: String = "100") async throws -> [Gist] {
        let router = GistRouter.readGists(configuration, owner, page, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Gist].self)
    }
    #endif

    /**
     Fetches an gist
     - parameter id: The id of the gist.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func gist(id: String, completion: @escaping (_ response: Result<Gist, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.readGist(configuration, id)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let gist = gist {
                    completion(.success(gist))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches an gist
     - parameter id: The id of the gist.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func gist(id: String) async throws -> Gist {
        let router = GistRouter.readGist(configuration, id)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Gist.self)
    }
    #endif

    /**
     Creates an gist with a single file.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter publicAccess: The public/private visability of the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func postGistFile(description: String,
                      filename: String,
                      fileContent: String,
                      publicAccess: Bool,
                      completion: @escaping (_ response: Result<Gist, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.postGistFile(configuration, description, filename, fileContent, publicAccess)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let gist = gist {
                    completion(.success(gist))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Creates an gist with a single file.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter publicAccess: The public/private visability of the gist.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func postGistFile(description: String, filename: String, fileContent: String, publicAccess: Bool) async throws -> Gist {
        let router = GistRouter.postGistFile(configuration, description, filename, fileContent, publicAccess)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Gist.self)
    }
    #endif

    /**
     Edits an gist with a single file.
     - parameter id: The of the gist to update.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     - parameter completion: Callback for the gist that is created.
     */
    @discardableResult
    func patchGistFile(id: String,
                       description: String,
                       filename: String,
                       fileContent: String,
                       completion: @escaping (_ response: Result<Gist, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GistRouter.patchGistFile(configuration, id, description, filename, fileContent)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Gist.self) { gist, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let gist = gist {
                    completion(.success(gist))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Edits an gist with a single file.
     - parameter id: The of the gist to update.
     - parameter description: The description of the gist.
     - parameter filename: The name of the file in the gist.
     - parameter fileContent: The content of the file in the gist.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func patchGistFile(id: String, description: String, filename: String, fileContent: String) async throws -> Gist {
        let router = GistRouter.patchGistFile(configuration, id, description, filename, fileContent)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Gist.self)
    }
    #endif
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
