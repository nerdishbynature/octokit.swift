import Foundation
import RequestKit

open class PullRequest: Codable {
    private(set) open var id: Int = -1
    open var url: URL?

    open var htmlURL: URL?
    open var diffURL: URL?
    open var patchURL: URL?
    open var issueURL: URL?
    open var commitsURL: URL?
    open var reviewCommentsURL: URL?
    open var reviewCommentURL: URL?
    open var commentsURL: URL?
    open var statusesURL: URL?

    open var title: String?
    open var body: String?
    
    open var assignee: User?
    open var milestone: Milestone?
    
    open var locked: Bool?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedAt: Date?
    open var mergedAt: Date?
    
    open var user: User?
    open var number: Int?
    open var state: Openness?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case diffURL = "diff_url"
        case patchURL = "patch_url"
        case issueURL = "issue_url"
        case commitsURL = "commits_url"
        case reviewCommentsURL = "review_comments_url"
        case commentsURL = "comments_url"
        case statusesURL = "statuses_url"
        case number
        case state
        case title
        case body
        case assignee
        case milestone
        case locked
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mergedAt = "merged_at"
    }
}


// MARK: Request

public extension Octokit {

    /**
    Get a single pull request
    - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
    - parameter owner: The user or organization that owns the repositories.
    - parameter repository: The name of the repository.
    - parameter number: The number of the PR to fetch.
    - parameter completion: Callback for the outcome of the fetch.
    */
    public func pullRequest(_ session: RequestKitURLSession = URLSession.shared,
                            owner: String,
                            repository: String,
                            number: Int,
                            completion: @escaping (_ response: Response<PullRequest>) -> Void) -> URLSessionDataTaskProtocol? {

        let router = PullRequestRouter.readPullRequest(configuration, owner, repository, "\(number)")
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: PullRequest.self) { pullRequest, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let pullRequest = pullRequest {
                    completion(Response.success(pullRequest))
                }
            }
        }
    }

    /**
    Get a list of pull requests
    - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
    - parameter owner: The user or organization that owns the repositories.
    - parameter repository: The name of the repository.
    - parameter base: Filter pulls by base branch name.
    - parameter state: Filter pulls by their state.
    - parameter direction: The direction of the sort.
    - parameter completion: Callback for the outcome of the fetch.
    */
    public func pullRequests(_ session: RequestKitURLSession = URLSession.shared,
                             owner: String,
                             repository: String,
                             base: String? = nil,
                             state: Openness = .Open,
                             sort: SortType = .created,
                             direction: SortDirection = .desc,
                             completion: @escaping (_ response: Response<[PullRequest]>) -> Void) -> URLSessionDataTaskProtocol? {

        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, state, sort, direction)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest].self) { pullRequests, error in
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

// MARK: Router

enum PullRequestRouter: JSONPostRouter {
    case readPullRequest(Configuration, String, String, String)
    case readPullRequests(Configuration, String, String, String?, Openness, SortType, SortDirection)

    var method: HTTPMethod {
        switch self {
        case .readPullRequest,
             .readPullRequests:
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
        case .readPullRequest(let config, _, _, _): return config
        case .readPullRequests(let config, _, _, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readPullRequest(_, _, _, _):
            return [:]
        case .readPullRequests(_, _, _, let base, let state, let sort, let direction):
            var parameters = [
                    "state": state.rawValue,
                    "sort": sort.rawValue,
                    "direction": direction.rawValue
            ]

            if let base = base {
                parameters["base"] = base
            }

            return parameters
        }
    }

    var path: String {
        switch self {
        case .readPullRequest(_, let owner, let repository, let number):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case .readPullRequests(_, let owner, let repository, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        }
    }
}
