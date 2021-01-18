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
        case comment = "COMMENT"
        case dismissed = "DISMISSED"
        case pending = "PENDING"
    }
}

public extension Octokit {
    @discardableResult
    func listReviews(
        _ session: RequestKitURLSession = URLSession.shared,
        owner: String,
        repository: String,
        pullRequestNumber: Int,
        completion: @escaping (_ response: Response<[Review]>) -> Void
    ) -> URLSessionDataTaskProtocol? {
        let router = ReviewsRouter.listReviews(configuration, owner, repository, pullRequestNumber)
        return router.load(
            session,
            dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter),
            expectedResultType: [Review].self
        ) { pullRequests, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let pullRequests = pullRequests {
                    completion(Response.success(pullRequests))
                }
            }
        }
    }
}

enum ReviewsRouter: JSONPostRouter {
    case listReviews(Configuration, String, String, Int)

    var method: HTTPMethod {
        switch self {
        case .listReviews:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .listReviews(config, _, _, _):
            return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .listReviews:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .listReviews(_, owner, repository, pullRequestNumber):
            return "/repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews"
        }
    }
}
