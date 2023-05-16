import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct Review {
    public let body: String
    public let commitID: String
    public let id: Int
    public let state: State
    public let submittedAt: Date
    public let user: User
}

extension Review: Codable {
    enum CodingKeys: String, CodingKey {
        case body
        case commitID = "commit_id"
        case id
        case state
        case submittedAt = "submitted_at"
        case user
    }
}

public extension Review {
    enum State: String, Codable, Equatable {
        case approved = "APPROVED"
        case changesRequested = "CHANGES_REQUESTED"
        case comment = "COMMENTED"
        case dismissed = "DISMISSED"
        case pending = "PENDING"
    }
}

public extension Review {
    enum Event: String, Codable {
        case approve = "APPROVE"
        case requestChanges = "REQUEST_CHANGES"
        case comment = "COMMENT"
        case pending = "PENDING"
    }

    struct Comment: Codable {
        var path: String
        var position: Int?
        var body: String
        var line: Int?
        var side: String?
        var startLine: Int?
        var startSide: String?
    }
}

extension Review.Comment {
    enum CodingKeys: String, CodingKey {
        case path
        case position
        case body
        case line
        case side
        case startLine = "start_line"
        case startSide = "start_side"
    }
}

public extension Octokit {
    @discardableResult
    func listReviews(_ session: RequestKitURLSession = URLSession.shared,
                     owner: String,
                     repository: String,
                     pullRequestNumber: Int,
                     completion: @escaping (_ response: Result<[Review], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReviewsRouter.listReviews(configuration, owner, repository, pullRequestNumber)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Review].self) { pullRequests, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let pullRequests = pullRequests {
                    completion(.success(pullRequests))
                }
            }
        }
    }

    @discardableResult
    func postReview(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String,
                    pullRequestNumber: Int,
                    commitId: String? = nil,
                    event: Review.Event? = nil,
                    body: String? = nil,
                    comments: [Review.Comment] = [],
                    completion: @escaping (_ response: Result<Review, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReviewsRouter.postReview(configuration, owner, repository, pullRequestNumber, commitId, event, body, comments)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Review.self) { pullRequest, error in
            if let error = error {
                completion(.failure(error))
            } else if let pullRequest = pullRequest {
                completion(.success(pullRequest))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func reviews(_ session: RequestKitURLSession = URLSession.shared,
                 owner: String,
                 repository: String,
                 pullRequestNumber: Int) async throws -> [Review] {
        let router = ReviewsRouter.listReviews(configuration, owner, repository, pullRequestNumber)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Review].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @discardableResult
    func postReview(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String,
                    pullRequestNumber: Int,
                    commitId: String? = nil,
                    event: Review.Event,
                    body: String? = nil,
                    comments: [Review.Comment] = []) async throws -> Review {
        let router = ReviewsRouter.postReview(configuration, owner, repository, pullRequestNumber, commitId, event, body, comments)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Review.self)
    }
    #endif
}

enum ReviewsRouter: JSONPostRouter {
    case listReviews(Configuration, String, String, Int)
    case postReview(Configuration, String, String, Int, String?, Review.Event?, String?, [Review.Comment]?)

    var method: HTTPMethod {
        switch self {
        case .listReviews:
            return .GET
        case .postReview:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postReview:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .listReviews(config, _, _, _):
            return config
        case let .postReview(config, _, _, _, _, _, _, _):
            return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .listReviews:
            return [:]
        case let .postReview(_, _, _, _, commitId, event, body, comments):
            var parameters = [String: Any]()
            if let commitId = commitId  {
                parameters["commit_id"] = commitId
            }
            if let event = event {
                parameters["event"] = event.rawValue
            }
            if let body = body {
                parameters["body"] = body
            }
            if let comments = comments {
                parameters["comments"] = comments.map {
                    var parameters: [String: Any] = [
                        "path": $0.path,
                        "body": $0.body
                    ]
                    if let position = $0.position {
                        parameters["position"] = position
                    }
                    if let line = $0.line {
                        parameters["line"] = line
                    }
                    if let side = $0.side {
                        parameters["side"] = side
                    }
                    if let startLine = $0.startLine {
                        parameters["start_line"] = startLine
                    }
                    if let startSide = $0.startSide {
                        parameters["start_side"] = startSide
                    }
                    return parameters
                }
            }
            return parameters
        }
    }

    var path: String {
        switch self {
        case let .listReviews(_, owner, repository, pullRequestNumber):
            return "repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews"
        case let .postReview(_, owner, repository, pullRequestNumber, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews"
        }
    }
}
