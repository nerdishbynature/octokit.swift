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

    @discardableResult
    func createCommitStatus(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            sha: String,
                            state: Status.State,
                            targetURL: String? = nil,
                            description: String? = nil,
                            context: String? = nil,
                            completion: @escaping (_ response: Response<Status>) -> Void) -> URLSessionDataTaskProtocol? {

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

    @discardableResult
    func listCommitStatuses(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            ref: String,
                            completion: @escaping (_ response: Response<[Status]>) -> Void) -> URLSessionDataTaskProtocol? {

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
        case .createCommitStatus(let config, _, _, _, _, _, _, _):
            return config
        case .listCommitStatuses(let config, _, _, _):
            return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .createCommitStatus(_, _, _, _, let state, let targetURL, let description, let context):
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
        case .createCommitStatus(_, let owner, let repo, let sha, _, _, _, _):
            return "repos/\(owner)/\(repo)/statuses/\(sha)"
        case .listCommitStatuses(_, let owner, let repo, let ref):
            return "repos/\(owner)/\(repo)/commits/\(ref)/statuses"
        }
    }
}
