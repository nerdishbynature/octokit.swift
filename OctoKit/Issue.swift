import Foundation
import RequestKit

// MARK: model

@objc public class PullRequest: NSObject {
    public var url: String?
    public var htmlUrl: String?
    public var diffUrl: String?
    public var patchUrl: String?
    
    public init(_ json: [String: AnyObject]) {
        url = json["url"] as? String
        htmlUrl = json["html_url"] as? String
        diffUrl = json["diff_url"] as? String
        patchUrl = json["patch_url"] as? String
    }
}

@objc public class Issue: NSObject {
    public let id: Int
    public var url: String?
    public var htmlUrl: String?
    public var number: Int?
    public var title: String?
    public var body: String?
    public var state: String?
    public var user: User
    public var assignee: User?
    public var pullRequest: PullRequest?
    public var createdAt: NSDate?
    public var closedAt: NSDate?
    public var updatedAt: NSDate?
    
    public init(_ json: [String: AnyObject]) {
        user = User(json["user"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            url = json["url"] as? String
            htmlUrl = json["html_url"] as? String
            number = json["number"] as? Int
            title = json["title"] as? String
            body = json["body"] as? String
            state = json["state"] as? String
            if let assigneeJson = json["assignee"] as? [String: AnyObject] {
                assignee = User(assigneeJson)
            }
            if let pullRequestJson = json["pull_request"] as? [String: AnyObject] {
                pullRequest = PullRequest(pullRequestJson)
            }
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
     Fetches the issues and pull requests of the authenticated user
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func myIssuesAndPullRequests(completion: (response: Response<[Issue]>) -> Void) {
        let router = IssueRouter.ReadAuthenticatedIssues(configuration)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let issuesAndPullRequests = json.map { Issue($0) }
                    completion(response: Response.Success(issuesAndPullRequests))
                }
            }
        }
    }
    
    /**
     Fetches the issues of the authenticated user
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func myIssues(completion: (response: Response<[Issue]>) -> Void) {
        myIssuesAndPullRequests { response in
            switch response {
            case .Success(let issuesAndPullRequests):
                let issues = issuesAndPullRequests.filter() {
                    return $0.pullRequest == nil
                }
                completion(response: Response.Success(issues))
            case .Failure(let error):
                completion(response: Response.Failure(error))
            }
        }
    }
    
    
    /**
     Fetches the pull requests of the authenticated user
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func myPullRequests(completion: (response: Response<[Issue]>) -> Void) {
        myIssuesAndPullRequests { response in
            switch response {
            case .Success(let issues):
                let pullRequests = issues.filter() {
                    return $0.pullRequest != nil
                }
                completion(response: Response.Success(pullRequests))
            case .Failure(let error):
                completion(response: Response.Failure(error))
            }
        }
    }
}

// MARK: Router

enum IssueRouter: Router {
    case ReadAuthenticatedIssues(Configuration)
    
    var method: HTTPMethod {
        return .GET
    }
    
    var encoding: HTTPEncoding {
        return .URL
    }
    
    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedIssues(let config): return config
        }
    }
    
    var path: String {
        switch self {
        case .ReadAuthenticatedIssues:
            return "user/issues"
        }
    }
    
    var params: [String: String] {
        return [:]
    }
}


