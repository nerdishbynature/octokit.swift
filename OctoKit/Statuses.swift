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

    public init(id: Int,
                url: String? = nil,
                avatarURL: String? = nil,
                nodeId: String? = nil,
                state: State? = nil,
                description: String? = nil,
                targetURL: String? = nil,
                context: String? = nil,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                creator: User? = nil) {
        self.id = id
        self.url = url
        self.avatarURL = avatarURL
        self.nodeId = nodeId
        self.state = state
        self.description = description
        self.targetURL = targetURL
        self.context = context
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.creator = creator
    }

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
    func createCommitStatus(owner: String,
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
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter sha: The commit SHA.
     - parameter state: The state of the status. Can be one of `.error`, `.failure`, `.pending`, or `.success`.
     - parameter targetURL: The target URL to associate with this status. This URL will be linked from the GitHub UI to allow users to easily see the source of the status.
     - parameter description: A short description of the status.
     - parameter context: A string label to differentiate this status from the status of other systems.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func createCommitStatus(owner: String,
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
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter ref: SHA, a branch name, or a tag name.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func listCommitStatuses(owner: String,
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
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter ref: SHA, a branch name, or a tag name.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listCommitStatuses(owner: String,
                            repository: String,
                            ref: String) async throws -> [Status] {
        let router = StatusesRouter.listCommitStatuses(configuration, owner: owner, repo: repository, ref: ref)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Status].self)
    }
    #endif
}

// MARK: - Router

enum StatusesRouter: JSONPostRouter {
    case createCommitStatus(Configuration, owner: String, repo: String, sha: String, state: Status.State, targetURL: String?, description: String?, context: String?)
    case listCommitStatuses(Configuration, owner: String, repo: String, ref: String)

    var method: HTTPMethod {
        switch self {
        case .createCommitStatus:
            return .POST
        case .listCommitStatuses:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .createCommitStatus:
            return .json
        case .listCommitStatuses:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .createCommitStatus(config, _, _, _, _, _, _, _):
            return config
        case let .listCommitStatuses(config, _, _, _):
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
        }
    }

    var path: String {
        switch self {
        case let .createCommitStatus(_, owner, repo, sha, _, _, _, _):
            return "repos/\(owner)/\(repo)/statuses/\(sha)"
        case let .listCommitStatuses(_, owner, repo, ref):
            return "repos/\(owner)/\(repo)/commits/\(ref)/statuses"
        }
    }
}
