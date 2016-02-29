import Foundation
import RequestKit

// MARK: model

@objc public class Issue: NSObject {
    public let id: Int
    public var url: String?
    public var number: Int?
    public var title: String?
    public var body: String?
    public var state: String?
    public var user: User?
    public var assignee: User?
    public var createdAt: NSDate?
    public var closedAt: NSDate?
    public var updatedAt: NSDate?
    
    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            url = json["url"] as? String
            number = json["number"] as? Int
            title = json["title"] as? String
            body = json["body"] as? String
            state = json["state"] as? String
            user = User(json["user"] as? [String: AnyObject] ?? [:])
            assignee = User(json["assignee"] as? [String: AnyObject] ?? [:])
            createdAt = Time.rfc3339Date(json["created_at"] as? String)
            closedAt = Time.rfc3339Date(json["closed_at"] as? String)
            updatedAt = Time.rfc3339Date(json["updated_at"] as? String)
        } else {
            id = -1
        }
    }
}

// MARK: request

public extension Octokit {
    
    /**
     Fetches the issues of the authenticated user
     - parameter page: Current page for issue pagination. `1` by default.
     - parameter perPage: Number of issues per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func myIssues(page: String = "1", perPage: String = "100", completion: (response: Response<[Issue]>) -> Void) {
        let router = IssueRouter.ReadAuthenticatedIssues(configuration, page, perPage)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedIssues = json.map { Issue($0) }
                    completion(response: Response.Success(parsedIssues))
                }
            }
        }
    }
}

// MARK: Router

enum IssueRouter: Router {
    case ReadAuthenticatedIssues(Configuration, String, String)
    
    var method: HTTPMethod {
        return .GET
    }
    
    var encoding: HTTPEncoding {
        return .URL
    }
    
    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedIssues(let config, _, _):
            return config
        }
    }
    
    var params: [String: String] {
        switch self {
        case .ReadAuthenticatedIssues(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        }
    }
    
    var path: String {
        switch self {
        case .ReadAuthenticatedIssues:
            return "issues"
        }
    }
}


