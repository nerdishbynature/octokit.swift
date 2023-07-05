import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class PullRequest: Codable {
    open private(set) var id: Int
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

    public init(id: Int = -1,
                url: URL? = nil,
                htmlURL: URL? = nil,
                diffURL: URL? = nil,
                patchURL: URL? = nil,
                issueURL: URL? = nil,
                commitsURL: URL? = nil,
                reviewCommentsURL: URL? = nil,
                reviewCommentURL: URL? = nil,
                commentsURL: URL? = nil,
                statusesURL: URL? = nil,
                title: String? = nil,
                body: String? = nil,
                assignee: User? = nil,
                milestone: Milestone? = nil,
                locked: Bool? = nil,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                closedAt: Date? = nil,
                mergedAt: Date? = nil,
                user: User? = nil,
                number: Int,
                state: Openness? = nil,
                labels: [Label]? = nil,
                head: PullRequest.Branch? = nil,
                base: PullRequest.Branch? = nil,
                requestedReviewers: [User]? = nil,
                draft: Bool? = nil) {
        self.id = id
        self.url = url
        self.htmlURL = htmlURL
        self.diffURL = diffURL
        self.patchURL = patchURL
        self.issueURL = issueURL
        self.commitsURL = commitsURL
        self.reviewCommentsURL = reviewCommentsURL
        self.reviewCommentURL = reviewCommentURL
        self.commentsURL = commentsURL
        self.statusesURL = statusesURL
        self.title = title
        self.body = body
        self.assignee = assignee
        self.milestone = milestone
        self.locked = locked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.closedAt = closedAt
        self.mergedAt = mergedAt
        self.user = user
        self.number = number
        self.state = state
        self.labels = labels
        self.head = head
        self.base = base
        self.requestedReviewers = requestedReviewers
        self.draft = draft
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
    }

    open class Branch: Codable {
        open var label: String?
        open var ref: String?
        open var sha: String?
        open var user: User?
        open var repo: Repository?
    }
}

public extension PullRequest {
    struct File: Codable {
        public var sha: String
        public var filename: String
        public var status: Status
        public var additions: Int
        public var deletions: Int
        public var changes: Int
        public var blobUrl: String
        public var rawUrl: String
        public var contentsUrl: String
        public var patch: String
    }
}

public extension PullRequest.File {
    enum Status: String, Codable {
        case added
        case removed
        case modified
        case renamed
        case copied
        case changed
        case unchanged
    }
}

extension PullRequest.File {
    enum CodingKeys: String, CodingKey {
        case sha
        case filename
        case status
        case additions
        case deletions
        case changes
        case blobUrl = "blob_url"
        case rawUrl = "raw_url"
        case contentsUrl = "contents_url"
        case patch
    }
}

// MARK: Request

public extension Octokit {
    /**
     Create a pull request
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter title: The title of the new pull request.
     - parameter head: The name of the branch where your changes are implemented.
     - parameter headRepo: The name of the repository where the changes in the pull request were made.
     - parameter base: The name of the branch you want the changes pulled into.
     - parameter body: The contents of the pull request.
     - parameter maintainerCanModify: Indicates whether maintainers can modify the pull request.
     - parameter draft: Indicates whether the pull request is a draft.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func createPullRequest(owner: String,
                           repo: String,
                           title: String,
                           head: String,
                           headRepo: String? = nil,
                           base: String,
                           body: String? = nil,
                           maintainerCanModify: Bool? = nil,
                           draft: Bool? = nil,
                           completion: @escaping (_ response: Result<PullRequest, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.createPullRequest(configuration, owner, repo, title, head, headRepo, base, body, maintainerCanModify, draft)
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
     Create a pull request
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter title: The title of the new pull request.
     - parameter head: The name of the branch where your changes are implemented.
     - parameter headRepo: The name of the repository where the changes in the pull request were made.
     - parameter base: The name of the branch you want the changes pulled into.
     - parameter body: The contents of the pull request.
     - parameter maintainerCanModify: Indicates whether maintainers can modify the pull request.
     - parameter draft: Indicates whether the pull request is a draft.
     - Returns: A PullRequest
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func createPullRequest(owner: String,
                           repo: String,
                           title: String,
                           head: String,
                           headRepo: String? = nil,
                           base: String,
                           body: String? = nil,
                           maintainerCanModify: Bool? = nil,
                           draft: Bool? = nil) async throws -> PullRequest {
        let router = PullRequestRouter.createPullRequest(configuration, owner, repo, title, head, headRepo, base, body, maintainerCanModify, draft)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: PullRequest.self)
    }
    #endif

    /**
     Get a single pull request
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to fetch.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequest(owner: String,
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
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter number: The number of the PR to fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func pullRequest(owner: String,
                     repository: String,
                     number: Int) async throws -> PullRequest {
        let router = PullRequestRouter.readPullRequest(configuration, owner, repository, "\(number)")
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: PullRequest.self)
    }
    #endif

    /**
     Get a list of pull requests
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter base: Filter pulls by base branch name.
     - parameter head: Filter pulls by user or organization and branch name.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func pullRequests(owner: String,
                      repository: String,
                      base: String? = nil,
                      head: String? = nil,
                      state: Openness = .open,
                      sort: SortType = .created,
                      direction: SortDirection = .desc,
                      completion: @escaping (_ response: Result<[PullRequest], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction)
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
     - parameter owner: The user or organization that owns the repositories.
     - parameter repository: The name of the repository.
     - parameter base: Filter pulls by base branch name.
     - parameter head: Filter pulls by user or organization and branch name.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func pullRequests(owner: String,
                      repository: String,
                      base: String? = nil,
                      head: String? = nil,
                      state: Openness = .open,
                      sort: SortType = .created,
                      direction: SortDirection = .desc) async throws -> [PullRequest] {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest].self)
    }
    #endif

    /**
     Updates a pull request
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
    func patchPullRequest(owner: String,
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
    func patchPullRequest(owner: String,
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

    func listPullRequestsFiles(owner: String,
                               repository: String,
                               number: Int,
                               perPage: Int? = nil,
                               page: Int? = nil,
                               completion: @escaping (_ response: Result<[PullRequest.File], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.listPullRequestsFiles(configuration, owner, repository, number, perPage, page)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest.File].self) { files, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let files = files {
                    completion(.success(files))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listPullRequestsFiles(owner: String,
                               repository: String,
                               number: Int,
                               perPage: Int? = nil,
                               page: Int? = nil) async throws -> [PullRequest.File] {
        let router = PullRequestRouter.listPullRequestsFiles(configuration, owner, repository, number, perPage, page)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest.File].self)
    }
    #endif
}

// MARK: Router

enum PullRequestRouter: JSONPostRouter {
    case readPullRequest(Configuration, String, String, String)
    case readPullRequests(Configuration, String, String, String?, String?, Openness, SortType, SortDirection)
    case createPullRequest(Configuration, String, String, String, String, String?, String, String?, Bool?, Bool?)
    case patchPullRequest(Configuration, String, String, String, String, String, Openness, String?, Bool?)
    case listPullRequestsFiles(Configuration, String, String, Int, Int?, Int?)

    var method: HTTPMethod {
        switch self {
        case .createPullRequest:
            return .POST
        case .readPullRequest,
             .readPullRequests,
             .listPullRequestsFiles:
            return .GET
        case .patchPullRequest:
            return .PATCH
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .patchPullRequest, .createPullRequest:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readPullRequest(config, _, _, _): return config
        case let .readPullRequests(config, _, _, _, _, _, _, _): return config
        case let .patchPullRequest(config, _, _, _, _, _, _, _, _): return config
        case let .createPullRequest(config, _, _, _, _, _, _, _, _, _): return config
        case let .listPullRequestsFiles(config, _, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readPullRequest:
            return [:]
        case let .readPullRequests(_, _, _, base, head, state, sort, direction):
            var parameters = [
                "state": state.rawValue,
                "sort": sort.rawValue,
                "direction": direction.rawValue
            ]

            if let base = base {
                parameters["base"] = base
            }

            if let head = head {
                parameters["head"] = head
            }

            return parameters
        case let .patchPullRequest(_, _, _, _, title, body, state, base, mantainerCanModify):
            var parameters: [String: Any] = [
                "title": title,
                "state": state.rawValue,
                "body": body
            ]
            if let base = base {
                parameters["base"] = base
            }
            if let mantainerCanModify = mantainerCanModify {
                parameters["maintainer_can_modify"] = mantainerCanModify
            }
            return parameters

        case let .createPullRequest(_, _, _, title, head, headRepo, base, body, mantainerCanModify, draft):
            var parameters: [String: Any] = [
                "title": title,
                "head": head,
                "base": base
            ]
            if let headRepo = headRepo {
                parameters["head_repo"] = headRepo
            }
            if let body = body {
                parameters["body"] = body
            }
            if let mantainerCanModify = mantainerCanModify {
                parameters["maintainer_can_modify"] = mantainerCanModify
            }
            if let draft = draft {
                parameters["draft"] = draft
            }
            return parameters
        case let .listPullRequestsFiles(_, _, _, _, perPage, page):
            var parameters: [String: Any] = [:]
            if let perPage = perPage {
                parameters["per_page"] = perPage
            }
            if let page = page {
                parameters["page"] = page
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
        case let .readPullRequests(_, owner, repository, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        case let .createPullRequest(_, owner, repository, _, _, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        case let .listPullRequestsFiles(_, owner, repository, number, _, _):
            return "/repos/\(owner)/\(repository)/pulls/\(number)/files"
        }
    }
}
