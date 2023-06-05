import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Model

open class Status: Codable {
    open private(set) var id: Int = -1
    open var url: String?
    open var avatarURL: String?
    open var nodeId: String?
    open var state: State?
    open var description: String?
    open var targetURL: String?
    open var context: String?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var creator: User?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case avatarURL = "avatar_url"
        case nodeId = "node_id"
        case state
        case description
        case targetURL = "target_url"
        case context
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case creator
    }

    public enum State: String, Codable {
        case error
        case failure
        case pending
        case success
    }
}

// MARK: - Request

public extension Octokit {
    /**
     Creates a commit status
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter sha: The commit SHA.
     - parameter state: The state of the status. Can be one of `.error`, `.failure`, `.pending`, or `.success`.
     - parameter targetURL: The target URL to associate with this status. This URL will be linked from the GitHub UI to allow users to easily see the source of the status.
     - parameter description: A short description of the status.
     - parameter context: A string label to differentiate this status from the status of other systems.
     - parameter completion: Callback for the outcome of the request.
     */
    @discardableResult
    func createCommitStatus(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            sha: String,
                            state: Status.State,
                            targetURL: String? = nil,
                            description: String? = nil,
                            context: String? = nil,
                            completion: @escaping (_ response: Result<Status, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StatusesRouter.createCommitStatus(configuration, owner: owner, repo: repository, sha: sha, state: state, targetURL: targetURL, description: description, context: context)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Status.self) { status, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let status = status {
                    completion(.success(status))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Creates a commit status
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter sha: The commit SHA.
     - parameter state: The state of the status. Can be one of `.error`, `.failure`, `.pending`, or `.success`.
     - parameter targetURL: The target URL to associate with this status. This URL will be linked from the GitHub UI to allow users to easily see the source of the status.
     - parameter description: A short description of the status.
     - parameter context: A string label to differentiate this status from the status of other systems.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func createCommitStatus(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            sha: String,
                            state: Status.State,
                            targetURL: String? = nil,
                            description: String? = nil,
                            context: String? = nil) async throws -> Status {
        let router = StatusesRouter.createCommitStatus(configuration, owner: owner, repo: repository, sha: sha, state: state, targetURL: targetURL, description: description, context: context)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Status.self)
    }
    #endif

    /**
     Fetches commit statuses for a reference
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter ref: SHA, a branch name, or a tag name.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func listCommitStatuses(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            ref: String,
                            completion: @escaping (_ response: Result<[Status], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = StatusesRouter.listCommitStatuses(configuration, owner: owner, repo: repository, ref: ref)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Status].self) { statuses, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let statuses = statuses {
                    completion(.success(statuses))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches commit statuses for a reference
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter ref: SHA, a branch name, or a tag name.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listCommitStatuses(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            ref: String) async throws -> [Status] {
        let router = StatusesRouter.listCommitStatuses(configuration, owner: owner, repo: repository, ref: ref)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Status].self)
    }
    #endif

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches pull requests associated with a commit.

     https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-pull-requests-associated-with-a-commit
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter sha: SHA of the commit.
     - parameter page: Current page for repository pagination. `1` by default.
     - parameter perPage: Number of pull requests per page. `100` by default.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listCommitPullRequests(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            sha: String,
                            page: Int = 1,
                            perPage: Int = 100
    ) async throws -> [PullRequest] {
        let router = StatusesRouter.listCommitPullRequests(configuration, owner: owner, repo: repository, sha: sha, page: page, perPage: perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest].self)
    }
    #endif
}

// MARK: - Router

enum StatusesRouter: JSONPostRouter {
    case createCommitStatus(Configuration, owner: String, repo: String, sha: String, state: Status.State, targetURL: String?, description: String?, context: String?)
    case listCommitStatuses(Configuration, owner: String, repo: String, ref: String)
    case listCommitPullRequests(Configuration, owner: String, repo: String, sha: String, page: Int, perPage: Int)

    var method: HTTPMethod {
        switch self {
        case .createCommitStatus:
            return .POST
        case .listCommitStatuses, .listCommitPullRequests:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .createCommitStatus:
            return .json
        case .listCommitStatuses, .listCommitPullRequests:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .createCommitStatus(config, _, _, _, _, _, _, _):
            return config
        case let .listCommitStatuses(config, _, _, _), let .listCommitPullRequests(config, _, _, _, _, _):
            return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .createCommitStatus(_, _, _, _, state, targetURL, description, context):
            var params: [String: Any] = ["state": state.rawValue]
            if let targetURL = targetURL {
                params["target_url"] = targetURL
            }
            if let description = description {
                params["description"] = description
            }
            if let context = context {
                params["context"] = context
            }
            return params
        case .listCommitStatuses:
            return [:]
        case let .listCommitPullRequests(_, _, _, _, page, perPage):
            return ["page": "\(page)", "per_page": "\(perPage)"]
        }
    }

    var path: String {
        switch self {
        case let .createCommitStatus(_, owner, repo, sha, _, _, _, _):
            return "repos/\(owner)/\(repo)/statuses/\(sha)"
        case let .listCommitStatuses(_, owner, repo, ref):
            return "repos/\(owner)/\(repo)/commits/\(ref)/statuses"
        case let .listCommitPullRequests(_, owner, repo, sha, _, _):
            return "repos/\(owner)/\(repo)/commits/\(sha)/pulls"
        }
    }
}
