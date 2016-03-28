import Foundation
import RequestKit

public extension Octokit {

    /**
        Fetches the followers of the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myFollowers(session: RequestKitURLSession = NSURLSession.sharedSession(), completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowers(configuration)
        router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(response: Response.Success(parsedUsers))
                }
            }
        }
    }

    /**
        Fetches the followers of a user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter name: Name of the user
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func followers(session: RequestKitURLSession = NSURLSession.sharedSession(), name: String, completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadFollowers(name, configuration)
        router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(response: Response.Success(parsedUsers))
                }
            }
        }
    }

    /**
        Fetches the users following the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myFollowing(session: RequestKitURLSession = NSURLSession.sharedSession(), completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowing(configuration)
        router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(response: Response.Success(parsedUsers))
                }
            }
        }
    }

    /**
        Fetches the users following a user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter name: The name of the user
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func following(session: RequestKitURLSession = NSURLSession.sharedSession(), name: String, completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadFollowing(name, configuration)
        router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(response: Response.Success(parsedUsers))
                }
            }
        }
    }
}

enum FollowRouter: Router {
    case ReadAuthenticatedFollowers(Configuration)
    case ReadFollowers(String, Configuration)
    case ReadAuthenticatedFollowing(Configuration)
    case ReadFollowing(String, Configuration)

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedFollowers(let config): return config
        case .ReadFollowers(_, let config): return config
        case .ReadAuthenticatedFollowing(let config): return config
        case .ReadFollowing(_, let config): return config
        }
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedFollowers:
            return "user/followers"
        case .ReadFollowers(let username, _):
            return "users/\(username)/followers"
        case .ReadAuthenticatedFollowing:
            return "user/following"
        case .ReadFollowing(let username, _):
            return "users/\(username)/following"
        }
    }

    var params: [String: String] {
        return [:]
    }
}
