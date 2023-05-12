import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class PullRequest: Codable {
    open private(set) var id: Int = -1
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
    open var number: Int
    open var state: Openness?
    open var labels: [Label]?

    open var head: PullRequest.Branch?
    open var base: PullRequest.Branch?

    open var requestedReviewers: [User]?
    open var draft: Bool?
    open var autoMerge: AutoMerge?

    public struct AutoMerge: Codable {
        let enabledBy: User

        public enum MergeMethod: String, Codable { case squash, rebase, merge }
        let mergeMethod: MergeMethod

        enum CodingKeys: String, CodingKey {
            case enabledBy = "enabled_by"
            case mergeMethod = "merge_method"
        }
    }

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
        case htmlURL = "html_url"
        case number
        case state
        case title
        case body
        case assignee
        case milestone
        case locked
        case user
        case labels
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mergedAt = "merged_at"
        case head
        case base
        case requestedReviewers = "requested_reviewers"
        case draft
        case autoMerge = "auto_merge"
    }

    open class Branch: Codable {
        open var label: String?
        open var ref: String?
        open var sha: String?
        open var user: User?
        open var repo: Repository?
    }
}

// MARK: Request

public extension Octokit {
    /**
     Get a single pull request
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to fetch.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequest(_ session: RequestKitURLSession = URLSession.shared,
                     owner: String,
                     repository: String,
                     number: Int,
                     completion: @escaping (_ response: Result<PullRequest, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.readPullRequest(configuration, owner, repository, "\(number)")
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: PullRequest.self) { pullRequest, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let pullRequest = pullRequest {
                    completion(.success(pullRequest))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Get a single pull request
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func pullRequest(_ session: RequestKitURLSession = URLSession.shared,
                     owner: String,
                     repository: String,
                     number: Int) async throws -> PullRequest {
        let router = PullRequestRouter.readPullRequest(configuration, owner, repository, "\(number)")
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: PullRequest.self)
    }
    #endif

    /**
     Get a list of pull requests
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter base: Filter pulls by base branch name.
     - parameter head: Filter pulls by user or organization and branch name.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter perPage: The number of results per page (default 30, max 100).
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequests(_ session: RequestKitURLSession = URLSession.shared,
                      owner: String,
                      repository: String,
                      base: String? = nil,
                      head: String? = nil,
                      state: Openness = .open,
                      sort: SortType = .created,
                      direction: SortDirection = .desc,
                      perPage: Int = 30,
                      completion: @escaping (_ response: Result<[PullRequest], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest].self) { pullRequests, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let pullRequests = pullRequests {
                    completion(.success(pullRequests))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Get a list of pull requests
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter base: Filter pulls by base branch name.
     - parameter head: Filter pulls by user or organization and branch name.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter perPage: The number of results per page (default 30, max 100).
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func pullRequests(_ session: RequestKitURLSession = URLSession.shared,
                      owner: String,
                      repository: String,
                      base: String? = nil,
                      head: String? = nil,
                      state: Openness = .open,
                      sort: SortType = .created,
                      direction: SortDirection = .desc,
                      perPage: Int = 30) async throws -> [PullRequest] {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest].self)
    }
    #endif

    /**
     Updates a pull request
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to update.
     - parameter title: The new tite of the PR
     - parameter body: The new body of the PR
     - parameter state: The new state of the PR
     - parameter base: The new baseBranch of the PR
     - parameter mantainerCanModify: The new baseBranch of the PR
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func patchPullRequest(_ session: RequestKitURLSession = URLSession.shared,
                          owner: String,
                          repository: String,
                          number: Int,
                          title: String,
                          body: String,
                          state: Openness,
                          base: String?,
                          mantainerCanModify _: Bool?,
                          completion: @escaping (_ response: Result<PullRequest, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        guard state != .all else { fatalError("Openess.all is not supported as a setting") }
        let router = PullRequestRouter.patchPullRequest(configuration, owner, repository, "\(number)", title, body, state, base, nil)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: PullRequest.self) { pullRequest, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let pullRequest = pullRequest {
                    completion(.success(pullRequest))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Updates a pull request
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to update.
     - parameter title: The new tite of the PR
     - parameter body: The new body of the PR
     - parameter state: The new state of the PR
     - parameter base: The new baseBranch of the PR
     - parameter mantainerCanModify: The new baseBranch of the PR
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func patchPullRequest(_ session: RequestKitURLSession = URLSession.shared,
                          owner: String,
                          repository: String,
                          number: Int,
                          title: String,
                          body: String,
                          state: Openness,
                          base: String?,
                          mantainerCanModify _: Bool?) async throws -> PullRequest {
        guard state != .all else { fatalError("Openess.all is not supported as a setting") }
        let router = PullRequestRouter.patchPullRequest(configuration, owner, repository, "\(number)", title, body, state, base, nil)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: PullRequest.self)
    }
    #endif
}

// MARK: Router

enum PullRequestRouter: JSONPostRouter {
    case readPullRequest(Configuration, String, String, String)
    case readPullRequests(Configuration, String, String, String?, String?, Openness, SortType, SortDirection, Int)
    case patchPullRequest(Configuration, String, String, String, String, String, Openness, String?, Bool?)

    var method: HTTPMethod {
        switch self {
        case .readPullRequest,
             .readPullRequests:
            return .GET
        case .patchPullRequest:
            return .PATCH
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .patchPullRequest:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readPullRequest(config, _, _, _): return config
        case let .readPullRequests(config, _, _, _, _, _, _, _, _): return config
        case let .patchPullRequest(config, _, _, _, _, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readPullRequest:
            return [:]
        case let .readPullRequests(_, _, _, base, head, state, sort, direction, perPage):
            var parameters = [
                "state": state.rawValue,
                "sort": sort.rawValue,
                "direction": direction.rawValue,
                "per_page": perPage
            ] as [String : Any]

            if let base = base {
                parameters["base"] = base
            }

            if let head = head {
                parameters["head"] = head
            }

            return parameters
        case let .patchPullRequest(_, _, _, _, title, body, state, base, mantainerCanModify):
            var parameters = [
                "title": title,
                "state": state.rawValue,
                "body": body
            ]
            if let base = base {
                parameters["base"] = base
            }
            if let mantainerCanModify = mantainerCanModify {
                parameters["maintainer_can_modify"] = (mantainerCanModify ? "true" : "false")
            }
            return parameters
        }
    }

    var path: String {
        switch self {
        case let .patchPullRequest(_, owner, repository, number, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case let .readPullRequest(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case let .readPullRequests(_, owner, repository, _, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        }
    }
}
