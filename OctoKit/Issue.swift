import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model

public enum Openness: String, Codable {
    case open
    case closed
    case all
}

open class Issue: Codable {
    open private(set) var id: Int = -1
    open var url: URL?
    open var repositoryURL: URL?
    @available(*, deprecated)
    open var labelsURL: URL?
    open var commentsURL: URL?
    open var eventsURL: URL?
    open var htmlURL: URL?
    open var number: Int
    open var state: Openness?
    open var title: String?
    open var body: String?
    open var user: User?
    open var labels: [Label]?
    open var assignee: User?
    open var milestone: Milestone?
    open var locked: Bool?
    open var comments: Int?
    open var closedAt: Date?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedBy: User?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case repositoryURL = "repository_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case number
        case state
        case title
        case body
        case user
        case labels
        case assignee
        case milestone
        case locked
        case comments
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedBy = "closed_by"
    }
}

public struct Comment: Codable {
    public let id: Int
    public let url: URL
    public let htmlURL: URL
    public let body: String
    public let user: User
    public let createdAt: Date
    public let updatedAt: Date
    public let reactions: Reactions?

    enum CodingKeys: String, CodingKey {
        case id, url, body, user, reactions
        case htmlURL = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: request

public extension Octokit {
    /**
     Fetches the issues of the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter state: Issue state. Defaults to open if not specified.
     - parameter page: Current page for issue pagination. `1` by default.
     - parameter perPage: Number of issues per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myIssues(_ session: RequestKitURLSession = URLSession.shared,
                  state: Openness = .open,
                  page: String = "1",
                  perPage: String = "100",
                  completion: @escaping (_ response: Result<[Issue], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readAuthenticatedIssues(configuration, page, perPage, state)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self) { issues, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let issues = issues {
                    completion(.success(issues))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches the issues of the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter state: Issue state. Defaults to open if not specified.
     - parameter page: Current page for issue pagination. `1` by default.
     - parameter perPage: Number of issues per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func myIssues(_ session: RequestKitURLSession = URLSession.shared,
                  state: Openness = .open,
                  page: String = "1",
                  perPage: String = "100") async throws -> [Issue] {
        let router = IssueRouter.readAuthenticatedIssues(configuration, page, perPage, state)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self)
    }
    #endif

    /**
     Fetches an issue in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func issue(_ session: RequestKitURLSession = URLSession.shared,
               owner: String,
               repository: String,
               number: Int,
               completion: @escaping (_ response: Result<Issue, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssue(configuration, owner, repository, number)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Issue.self) { issue, error in
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
    /**
     Fetches an issue in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int) async throws -> Issue {
        let router = IssueRouter.readIssue(configuration, owner, repository, number)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Issue.self)
    }
    #endif

    /**
     Fetches all issues in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter state: Issue state. Defaults to open if not specified.
     - parameter page: Current page for issue pagination. `1` by default.
     - parameter perPage: Number of issues per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func issues(_ session: RequestKitURLSession = URLSession.shared,
                owner: String,
                repository: String,
                state: Openness = .open,
                page: String = "1",
                perPage: String = "100",
                completion: @escaping (_ response: Result<[Issue], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssues(configuration, owner, repository, page, perPage, state)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self) { issues, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let issues = issues {
                    completion(.success(issues))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Fetches all issues in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter state: Issue state. Defaults to open if not specified.
     - parameter page: Current page for issue pagination. `1` by default.
     - parameter perPage: Number of issues per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issues(_ session: RequestKitURLSession = URLSession.shared,
                owner: String,
                repository: String,
                state: Openness = .open,
                page: String = "1",
                perPage: String = "100") async throws -> [Issue] {
        let router = IssueRouter.readIssues(configuration, owner, repository, page, perPage, state)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self)
    }
    #endif

    /**
     Creates an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter labels: An array of label names to add to the issue. If the labels do not exist, GitHub will create them automatically. This parameter is ignored if the user lacks push access to the repository.
     - parameter completion: Callback for the issue that is created.
     */
    @discardableResult
    func postIssue(_ session: RequestKitURLSession = URLSession.shared,
                   owner: String,
                   repository: String,
                   title: String,
                   body: String? = nil,
                   assignee: String? = nil,
                   labels: [String] = [],
                   completion: @escaping (_ response: Result<Issue, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.postIssue(configuration, owner, repository, title, body, assignee, labels)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Issue.self) { issue, error in
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
    /**
     Creates an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter labels: An array of label names to add to the issue. If the labels do not exist, GitHub will create them automatically. This parameter is ignored if the user lacks push access to the repository.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func postIssue(_ session: RequestKitURLSession = URLSession.shared,
                   owner: String,
                   repository: String,
                   title: String,
                   body: String? = nil,
                   assignee: String? = nil,
                   labels: [String] = []) async throws -> Issue {
        let router = IssueRouter.postIssue(configuration, owner, repository, title, body, assignee, labels)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Issue.self)
    }
    #endif

    /**
     Edits an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter state: Whether the issue is open or closed.
     - parameter completion: Callback for the issue that is created.
     */
    @discardableResult
    func patchIssue(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String,
                    number: Int,
                    title: String? = nil,
                    body: String? = nil,
                    assignee: String? = nil,
                    state: Openness? = nil,
                    completion: @escaping (_ response: Result<Issue, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.patchIssue(configuration, owner, repository, number, title, body, assignee, state)
        return router.post(session, expectedResultType: Issue.self) { issue, error in
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
    /**
     Edits an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter state: Whether the issue is open or closed.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func patchIssue(_ session: RequestKitURLSession = URLSession.shared,
                    owner: String,
                    repository: String,
                    number: Int,
                    title: String? = nil,
                    body: String? = nil,
                    assignee: String? = nil,
                    state: Openness? = nil) async throws -> Issue {
        let router = IssueRouter.patchIssue(configuration, owner, repository, number, title, body, assignee, state)
        return try await router.post(session, expectedResultType: Issue.self)
    }
    #endif

    /// Posts a comment on an issue using the given body.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the issue.
    ///   - body: The contents of the comment.
    ///   - completion: Callback for the comment that is created.
    @discardableResult
    func commentIssue(_ session: RequestKitURLSession = URLSession.shared,
                      owner: String,
                      repository: String,
                      number: Int,
                      body: String,
                      completion: @escaping (_ response: Result<Comment, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.commentIssue(configuration, owner, repository, number, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Comment.self) { issue, error in
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
    /// Posts a comment on an issue using the given body.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the issue.
    ///   - body: The contents of the comment.
    ///   - completion: Callback for the comment that is created.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func commentIssue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, body: String) async throws -> Comment {
        let router = IssueRouter.commentIssue(configuration, owner, repository, number, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Comment.self)
    }
    #endif

    /// Fetches all comments for an issue
    /// - Parameters:
    /// - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    /// - owner: The user or organization that owns the repository.
    /// - repository: The name of the repository.
    /// - number: The number of the issue.
    /// - page: Current page for comments pagination. `1` by default.
    /// - perPage: Number of comments per page. `100` by default.
    /// - completion: Callback for the outcome of the fetch.
    @discardableResult
    func issueComments(_ session: RequestKitURLSession = URLSession.shared,
                       owner: String,
                       repository: String,
                       number: Int,
                       page: String = "1",
                       perPage: String = "100",
                       completion: @escaping (_ response: Result<[Comment], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssueComments(configuration, owner, repository, number, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Comment].self) { comments, error in
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
    /// Fetches all comments for an issue
    /// - Parameters:
    /// - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    /// - owner: The user or organization that owns the repository.
    /// - repository: The name of the repository.
    /// - number: The number of the issue.
    /// - page: Current page for comments pagination. `1` by default.
    /// - perPage: Number of comments per page. `100` by default.
    /// - completion: Callback for the outcome of the fetch.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issueComments(_ session: RequestKitURLSession = URLSession.shared,
                       owner: String,
                       repository: String,
                       number: Int,
                       page: String = "1",
                       perPage: String = "100") async throws -> [Comment] {
        let router = IssueRouter.readIssueComments(configuration, owner, repository, number, page, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Comment].self)
    }
    #endif

    /// Edits a comment on an issue using the given body.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the comment.
    ///   - body: The contents of the comment.
    ///   - completion: Callback for the comment that is created.
    @discardableResult
    func patchIssueComment(_ session: RequestKitURLSession = URLSession.shared,
                           owner: String,
                           repository: String,
                           number: Int,
                           body: String,
                           completion: @escaping (_ response: Result<Comment, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.patchIssueComment(configuration, owner, repository, number, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Comment.self) { issue, error in
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
    /// Adds the given labels to a specific issue (or if the provided labels array is empty, removes all existing labels).
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the comment.
    ///   - labels: The labels to add to the issues’s existing labels, or removes all if an empty array is sent.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func patchIssueLabels(_ session: RequestKitURLSession = URLSession.shared,
                           owner: String,
                           repository: String,
                           number: Int,
                           labels: [String]) async throws -> [Label] {
        let router = IssueRouter.patchIssueLabels(configuration, owner, repository, number, labels)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: [Label].self)
    }
    #endif

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Edits a comment on an issue using the given body.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.sharedSession()
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the comment.
    ///   - body: The contents of the comment.
    ///   - completion: Callback for the comment that is created.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func patchIssueComment(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, body: String) async throws -> Comment {
        let router = IssueRouter.patchIssueComment(configuration, owner, repository, number, body)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Comment.self)
    }
    #endif
}

// MARK: Router

enum IssueRouter: JSONPostRouter {
    case readAuthenticatedIssues(Configuration, String, String, Openness)
    case readIssue(Configuration, String, String, Int)
    case readIssues(Configuration, String, String, String, String, Openness)
    case postIssue(Configuration, String, String, String, String?, String?, [String])
    case patchIssue(Configuration, String, String, Int, String?, String?, String?, Openness?)
    case commentIssue(Configuration, String, String, Int, String)
    case readIssueComments(Configuration, String, String, Int, String, String)
    case patchIssueComment(Configuration, String, String, Int, String)
    case patchIssueLabels(Configuration, String, String, Int, [String])

    var method: HTTPMethod {
        switch self {
        case .postIssue, .patchIssue, .commentIssue, .patchIssueComment, .patchIssueLabels:
            return .POST
        default:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postIssue, .patchIssue, .commentIssue, .patchIssueComment, .patchIssueLabels:
            return .json
        default:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .readAuthenticatedIssues(config, _, _, _): return config
        case let .readIssue(config, _, _, _): return config
        case let .readIssues(config, _, _, _, _, _): return config
        case let .postIssue(config, _, _, _, _, _, _): return config
        case let .patchIssue(config, _, _, _, _, _, _, _): return config
        case let .commentIssue(config, _, _, _, _): return config
        case let .readIssueComments(config, _, _, _, _, _): return config
        case let .patchIssueComment(config, _, _, _, _): return config
        case let .patchIssueLabels(config, _, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .readAuthenticatedIssues(_, page, perPage, state):
            return ["per_page": perPage, "page": page, "state": state.rawValue]
        case .readIssue:
            return [:]
        case let .readIssues(_, _, _, page, perPage, state):
            return ["per_page": perPage, "page": page, "state": state.rawValue]
        case let .postIssue(_, _, _, title, body, assignee, labels):
            var params: [String: Any] = ["title": title]
            if let body = body {
                params["body"] = body
            }
            if let assignee = assignee {
                params["assignee"] = assignee
            }
            if !labels.isEmpty {
                params["labels"] = labels
            }
            return params
        case let .patchIssue(_, _, _, _, title, body, assignee, state):
            var params: [String: String] = [:]
            if let title = title {
                params["title"] = title
            }
            if let body = body {
                params["body"] = body
            }
            if let assignee = assignee {
                params["assignee"] = assignee
            }
            if let state = state {
                params["state"] = state.rawValue
            }
            return params
        case let .commentIssue(_, _, _, _, body):
            return ["body": body]
        case let .readIssueComments(_, _, _, _, page, perPage):
            return ["per_page": perPage, "page": page]
        case let .patchIssueComment(_, _, _, _, body):
            return ["body": body]
        case let .patchIssueLabels(_, _, _, _, labels):
            return ["labels": labels]
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedIssues:
            return "issues"
        case let .readIssue(_, owner, repository, number):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        case let .readIssues(_, owner, repository, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case let .postIssue(_, owner, repository, _, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case let .patchIssue(_, owner, repository, number, _, _, _, _):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        case let .commentIssue(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/comments"
        case let .readIssueComments(_, owner, repository, number, _, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/comments"
        case let .patchIssueComment(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/comments/\(number)"
        case let .patchIssueLabels(_, owner, repository, number, _):
            return "repos/\(owner)/\(repository)/issues/\(number)/labels"
        }
    }
}
