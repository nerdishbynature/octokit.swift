import Foundation
import RequestKit

// MARK: model

public enum Openness: String, Codable {
    case Open = "open"
    case Closed = "closed"
    case All = "all"
}

open class Issue: Codable {
    open private(set) var id: Int = -1
    open var url: URL?
    open var repositoryURL: URL?
    open var commentsURL: URL?
    open var eventsURL: URL?
    open var htmlURL: URL?
    open var number: Int?
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
    public func myIssues(_ session: RequestKitURLSession = URLSession.shared, state: Openness = .Open, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Issue]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readAuthenticatedIssues(configuration, page, perPage, state)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self) { issues, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issues = issues {
                    completion(Response.success(issues))
                }
            }
        }
    }
    
    /**
     Fetches an issue in a repository
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter number: The number of the issue.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    public func issue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssue(configuration, owner, repository, number)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Issue.self) { issue, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issue = issue {
                    completion(Response.success(issue))
                }
            }
        }
    }

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
    public func issues(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, state: Openness = .Open, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Issue]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssues(configuration, owner, repository, page, perPage, state)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Issue].self) { issues, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issues = issues {
                    completion(Response.success(issues))
                }
            }
        }
    }

    /**
     Creates an issue in a repository.
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The user or organization that owns the repository.
     - parameter repository: The name of the repository.
     - parameter title: The title of the issue.
     - parameter body: The body text of the issue in GitHub-flavored Markdown format.
     - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
     - parameter completion: Callback for the issue that is created.
     */
    @discardableResult
    public func postIssue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, title: String, body: String? = nil, assignee: String? = nil, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.postIssue(configuration, owner, repository, title, body, assignee)
        return router.post(session, expectedResultType: Issue.self) { issue, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issue = issue {
                    completion(Response.success(issue))
                }
            }
        }
    }
    
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
    public func patchIssue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, title: String? = nil, body: String? = nil, assignee: String? = nil, state: Openness? = nil, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.patchIssue(configuration, owner, repository, number, title, body, assignee, state)
        return router.post(session, expectedResultType: Issue.self) { issue, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issue = issue {
                    completion(Response.success(issue))
                }
            }
        }
    }
}

// MARK: Router

enum IssueRouter: JSONPostRouter {
    case readAuthenticatedIssues(Configuration, String, String, Openness)
    case readIssue(Configuration, String, String, Int)
    case readIssues(Configuration, String, String, String, String, Openness)
    case postIssue(Configuration, String, String, String, String?, String?)
    case patchIssue(Configuration, String, String, Int, String?, String?, String?, Openness?)
    
    var method: HTTPMethod {
        switch self {
        case .postIssue, .patchIssue:
            return .POST
        default:
            return .GET
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        case .postIssue, .patchIssue:
            return .json
        default:
            return .url
        }
    }
    
    var configuration: Configuration {
        switch self {
        case .readAuthenticatedIssues(let config, _, _, _): return config
        case .readIssue(let config, _, _, _): return config
        case .readIssues(let config, _, _, _, _, _): return config
        case .postIssue(let config, _, _, _, _, _): return config
        case .patchIssue(let config, _, _, _, _, _, _, _): return config
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .readAuthenticatedIssues(_, let page, let perPage, let state):
            return ["per_page": perPage, "page": page, "state": state.rawValue]
        case .readIssue:
            return [:]
        case .readIssues(_, _, _, let page, let perPage, let state):
            return ["per_page": perPage, "page": page, "state": state.rawValue]
        case .postIssue(_, _, _, let title, let body, let assignee):
            var params = ["title": title]
            if let body = body {
                params["body"] = body
            }
            if let assignee = assignee {
                params["assignee"] = assignee
            }
            return params
        case .patchIssue(_, _, _, _, let title, let body, let assignee, let state):
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
        }
    }
    
    var path: String {
        switch self {
        case .readAuthenticatedIssues:
            return "issues"
        case .readIssue(_, let owner, let repository, let number):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        case .readIssues(_, let owner, let repository, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case .postIssue(_, let owner, let repository, _, _, _):
            return "repos/\(owner)/\(repository)/issues"
        case .patchIssue(_, let owner, let repository, let number, _, _, _, _):
            return "repos/\(owner)/\(repository)/issues/\(number)"
        }
    }
}
