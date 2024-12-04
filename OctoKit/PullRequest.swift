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

public extension PullRequest {
    struct Comment: Codable {
        public let id: Int
        public let url: URL
        public let htmlURL: URL
        public let body: String
        public let user: User
        public let createdAt: Date
        public let updatedAt: Date
        public let reactions: Reactions?
        
        /// The SHA of the commit this comment is associated with.
        public private(set) var commitId: String?
        /// The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
        public private(set) var line: Int?
        /// The first line in the pull request diff that the multi-line comment applies to.
        public private(set) var startLine: Int?
        /// The starting side of the diff that the comment applies to.
        public private(set) var side: Side?
        /// The level at which the comment is targeted.
        public private(set) var subjectType: SubjectType?
        /// The ID of the review comment this comment replied to.
        public private(set) var inReplyToId: Int?
        
        enum CodingKeys: String, CodingKey {
            case id, url, body, user, reactions
            case htmlURL = "html_url"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            
            case line, side
            case commitId = "commit_id"
            case startLine = "start_line"
            case inReplyToId = "in_reply_to_id"
        }
    }
}

public extension PullRequest.Comment {
    enum Side: String, Codable {
        case left = "LEFT"
        case right = "RIGHT"
        case side
    }
}

public extension PullRequest.Comment {
    enum SubjectType: String, Codable {
        case line, file
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
     - parameter page: The page to request.
     - parameter perPage: The number of pulls to return on each page, max is 100.
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
                      page: String? = nil,
                      perPage: String? = nil,
                      completion: @escaping (_ response: Result<[PullRequest], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction, page, perPage)
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
                      page: String? = nil,
                      perPage: String? = nil,
                      direction: SortDirection = .desc) async throws -> [PullRequest] {
        let router = PullRequestRouter.readPullRequests(configuration, owner, repository, base, head, state, sort, direction, page, perPage)
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
    
    /// Fetches all review comments for a pull request.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - page: Current page for comments pagination. `1` by default.
    ///   - perPage: Number of comments per page. `100` by default.
    ///   - completion: Callback for the outcome of the fetch.
    @discardableResult
    func readPullRequestReviewComments(owner: String,
                                       repository: String,
                                       number: Int,
                                       page: Int = 1,
                                       perPage: Int = 100,
                                       completion: @escaping (_ response: Result<[PullRequest.Comment], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.readPullRequestReviewComments(configuration, owner, repository, number, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest.Comment].self) { comments, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let comments = comments {
                    completion(.success(comments))
                }
            }
        }
    }
    
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Fetches all review comments for a pull request.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - page: Current page for comments pagination. `1` by default.
    ///   - perPage: Number of comments per page. `100` by default.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func readPullRequestReviewComments(owner: String,
                                       repository: String,
                                       number: Int,
                                       page: Int = 1,
                                       perPage: Int = 100) async throws -> [PullRequest.Comment] {
        let router = PullRequestRouter.readPullRequestReviewComments(configuration, owner, repository, number, page, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [PullRequest.Comment].self)
    }
    #endif
    
    /// Posts a review comment on a pull request using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - commitId: The SHA of the commit needing a comment.
    ///   - path: The relative path to the file that necessitates a comment.
    ///   - line: The line of the blob in the pull request diff that the comment applies to.
    ///   - body: The text of the review comment.
    ///   - completion: Callback for the comment that is created.
    @discardableResult
    func createPullRequestReviewComment(owner: String,
                                        repository: String,
                                        number: Int,
                                        commitId: String,
                                        path: String,
                                        line: Int,
                                        body: String,
                                        completion: @escaping (_ response: Result<PullRequest.Comment, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PullRequestRouter.createPullRequestReviewComment(configuration, owner, repository, number, commitId, path, line, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: PullRequest.Comment.self) { issue, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let issue = issue {
                    completion(.success(issue))
                }
            }
        }
    }
    
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Posts a review comment on a pull request using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - commitId: The SHA of the commit needing a comment.
    ///   - path: The relative path to the file that necessitates a comment.
    ///   - line: The line of the blob in the pull request diff that the comment applies to.
    ///   - body: The contents of the comment.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func createPullRequestReviewComment(owner: String,
                                        repository: String,
                                        number: Int,
                                        commitId: String,
                                        path: String,
                                        line: Int,
                                        body: String) async throws -> PullRequest.Comment {
        let router = PullRequestRouter.createPullRequestReviewComment(configuration, owner, repository, number, commitId, path, line, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: PullRequest.Comment.self)
    }
    #endif
    
    /// Posts a review comment on a pull request using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - body: The text of the review comment.
    ///   - completion: Callback for the comment that is created.
    @discardableResult
    func createPullRequestReviewComment(owner: String,
                                        repository: String,
                                        number: Int,
                                        body: String,
                                        completion: @escaping (_ response: Result<Issue.Comment, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        /// To add a regular comment to a pull request timeline, the Issue Comment API should be used.
        /// See: https://docs.github.com/en/rest/pulls/comments?apiVersion=2022-11-28#create-a-review-comment-for-a-pull-request
        commentIssue(owner: owner,
                     repository: repository,
                     number: number, body: body,
                     completion: completion)
    }
    
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Posts a review comment on a pull request using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the pull request.
    ///   - body: The contents of the comment.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func createPullRequestReviewComment(owner: String,
                                        repository: String,
                                        number: Int,
                                        body: String) async throws -> Issue.Comment {
        /// To add a regular comment to a pull request timeline, the Issue Comment API should be used.
        /// See: https://docs.github.com/en/rest/pulls/comments?apiVersion=2022-11-28#create-a-review-comment-for-a-pull-request
        try await commentIssue(owner: owner, repository: repository, number: number, body: body)
    }
    #endif
}

// MARK: Router

enum PullRequestRouter: JSONPostRouter {
    case readPullRequest(Configuration, String, String, String)
    case readPullRequests(Configuration, String, String, String?, String?, Openness, SortType, SortDirection, String?, String?)
    case createPullRequest(Configuration, String, String, String, String, String?, String, String?, Bool?, Bool?)
    case patchPullRequest(Configuration, String, String, String, String, String, Openness, String?, Bool?)
    case listPullRequestsFiles(Configuration, String, String, Int, Int?, Int?)
    case readPullRequestReviewComments(Configuration, String, String, Int, Int?, Int?)
    case createPullRequestReviewComment(Configuration, String, String, Int, String, String, Int, String)

    var method: HTTPMethod {
        switch self {
        case .createPullRequest,
            .createPullRequestReviewComment:
            return .POST
        case .readPullRequest,
             .readPullRequests,
             .listPullRequestsFiles,
             .readPullRequestReviewComments:
            return .GET
        case .patchPullRequest:
            return .PATCH
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .patchPullRequest,
             .createPullRequest,
             .createPullRequestReviewComment:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readPullRequest(config, _, _, _): return config
        case let .readPullRequests(config, _, _, _, _, _, _, _, _, _): return config
        case let .patchPullRequest(config, _, _, _, _, _, _, _, _): return config
        case let .createPullRequest(config, _, _, _, _, _, _, _, _, _): return config
        case let .listPullRequestsFiles(config, _, _, _, _, _): return config
        case let .readPullRequestReviewComments(config, _, _, _, _, _): return config
        case let .createPullRequestReviewComment(config, _, _, _, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case .readPullRequest:
            return [:]
        case let .readPullRequests(_, _, _, base, head, state, sort, direction, page, perPage):
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

            if let page = page {
                parameters["page"] = page
            }

            if let perPage = perPage {
                parameters["per_page"] = perPage
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
        case let .listPullRequestsFiles(_, _, _, _, perPage, page),
             let .readPullRequestReviewComments(_, _, _, _, page, perPage):
            var parameters: [String: Any] = [:]
            if let perPage {
                parameters["per_page"] = perPage
            }
            if let page {
                parameters["page"] = page
            }
            return parameters
        case let .createPullRequestReviewComment(_, _, _, _, commitId, path, line, body):
            return [
                "body": body,
                "commit_id": commitId,
                "path": path,
                "line": line
            ]
        }
    }

    var path: String {
        switch self {
        case let .patchPullRequest(_, owner, repository, number, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case let .readPullRequest(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/pulls/\(number)"
        case let .readPullRequests(_, owner, repository, _, _, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        case let .createPullRequest(_, owner, repository, _, _, _, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls"
        case let .listPullRequestsFiles(_, owner, repository, number, _, _):
            return "repos/\(owner)/\(repository)/pulls/\(number)/files"
        case let .readPullRequestReviewComments(_, owner, repository, number, _, _):
            /// See: https://docs.github.com/en/rest/pulls/comments?apiVersion=2022-11-28#list-review-comments-on-a-pull-request
            return "repos/\(owner)/\(repository)/pulls/\(number)/comments"
        case let .createPullRequestReviewComment(_, owner, repository, number, _, _, _, _):
            /// See: https://docs.github.com/en/rest/pulls/comments?apiVersion=2022-11-28#create-a-review-comment-for-a-pull-request
            return "repos/\(owner)/\(repository)/pulls/\(number)/comments"
        }
    }
}
