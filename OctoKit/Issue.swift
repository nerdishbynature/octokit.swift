import Foundation
import RequestKit

// MARK: model

public enum Openness: String {
    case Open = "open"
    case Closed = "closed"
    case All = "all"
}

@objc open class Issue: NSObject {
    open var id: Int
    open var url: URL?
    open var repositoryURL: URL?
    open var labelsURL: URL?
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
    
    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            if let urlString = json["url"] as? String, let url = URL(string: urlString) {
                self.url = url
            }
            if let urlString = json["repository_url"] as? String, let url = URL(string: urlString) {
                repositoryURL = url
            }
            if let urlString = json["labels_url"] as? String, let url = URL(string: urlString) {
                labelsURL = url
            }
            if let urlString = json["comments_url"] as? String, let url = URL(string: urlString) {
                commentsURL = url
            }
            if let urlString = json["events_url"] as? String, let url = URL(string: urlString) {
                eventsURL = url
            }
            if let urlString = json["html_url"] as? String, let url = URL(string: urlString) {
                htmlURL = url
            }
            number = json["number"] as? Int
            state = Openness(rawValue: json["state"] as? String ?? "")
            title = json["title"] as? String
            body = json["body"] as? String
            user = User(json["user"] as? [String: AnyObject] ?? [:])
            if let labelDictionaries = json["labels"] as? [[String: AnyObject]] {
                labels = labelDictionaries.flatMap { Label($0) }
            }
            assignee = User(json["assignee"] as? [String: AnyObject] ?? [:])
            milestone = Milestone(json["milestone"] as? [String: AnyObject] ?? [:])
            locked = json["locked"] as? Bool
            comments = json["comments"] as? Int
            closedAt = Time.rfc3339Date(json["closed_at"] as? String)
            createdAt = Time.rfc3339Date(json["created_at"] as? String)
            updatedAt = Time.rfc3339Date(json["updated_at"] as? String)
            closedBy = User(json["closed_by"] as? [String: AnyObject] ?? [:])
        } else {
            id = -1
        }
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
    public func myIssues(_ session: RequestKitURLSession = URLSession.shared, state: Openness = .Open, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Issue]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readAuthenticatedIssues(configuration, page, perPage, state)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedIssues = json.map { Issue($0) }
                    completion(Response.success(parsedIssues))
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
    public func issue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssue(configuration, owner, repository, number)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let issue = Issue(json)
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
    public func issues(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, state: Openness = .Open, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[Issue]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.readIssues(configuration, owner, repository, page, perPage, state)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedIssues = json.map { Issue($0) }
                    completion(Response.success(parsedIssues))
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
    public func postIssue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, title: String, body: String? = nil, assignee: String? = nil, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.postIssue(configuration, owner, repository, title, body, assignee)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let issue = Issue(json)
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
    public func patchIssue(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, number: Int, title: String? = nil, body: String? = nil, assignee: String? = nil, state: Openness? = nil, completion: @escaping (_ response: Response<Issue>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueRouter.patchIssue(configuration, owner, repository, number, title, body, assignee, state)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let issue = Issue(json)
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
