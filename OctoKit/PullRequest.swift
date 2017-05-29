import Foundation
import RequestKit

@objc open class PullRequest: NSObject {

    open var id: Int
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

    open var number: Int?
    open var state: Openness?
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

    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id

            if let urlString = json["url"] as? String, let url = URL(string: urlString) {
                self.url = url
            }
            if let diffURL = json["diff_url"] as? String, let url = URL(string: diffURL) {
                self.diffURL = url
            }
            if let patchURL = json["patch_url"] as? String, let url = URL(string: patchURL) {
                self.patchURL = url
            }
            if let issueURL = json["issue_url"] as? String, let url = URL(string: issueURL) {
                self.patchURL = url
            }
            if let commitsURL = json["commits_url"] as? String, let url = URL(string: commitsURL) {
                self.commitsURL = url
            }
            if let reviewCommentsURL = json["review_comments_url"] as? String,
               let url = URL(string: reviewCommentsURL) {
                self.reviewCommentsURL = url
            }
            if let reviewCommentURL = json["review_comment_url"] as? String, let url = URL(string: reviewCommentURL) {
                self.reviewCommentURL = url
            }
            if let commentsURL = json["comments_url"] as? String, let url = URL(string: commentsURL) {
                self.commentsURL = url
            }
            if let statusesURL = json["statuses_url"] as? String, let url = URL(string: statusesURL) {
                self.statusesURL = url
            }
            number = json["number"] as? Int
            state = Openness(rawValue: json["state"] as? String ?? "")
            title = json["title"] as? String
            body = json["body"] as? String

            assignee = User(json["assignee"] as? [String: AnyObject] ?? [:])
            milestone = Milestone(json["milestone"] as? [String: AnyObject] ?? [:])

            locked = json["locked"] as? Bool
            closedAt = Time.rfc3339Date(json["closed_at"] as? String)
            createdAt = Time.rfc3339Date(json["created_at"] as? String)
            updatedAt = Time.rfc3339Date(json["updated_at"] as? String)
            mergedAt = Time.rfc3339Date(json["merged_at"] as? String)
        } else {
            id = -1
        }
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
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedPullRequest = PullRequest(json)
                    completion(Response.success(parsedPullRequest))
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
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedPullRequest = json.map {
                        PullRequest($0)
                    }
                    completion(Response.success(parsedPullRequest))
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
