import Foundation
import RequestKit

public extension Octokit {

    /**
        Fetches the followers of the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myFollowers(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readAuthenticatedFollowers(configuration)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(Response.success(parsedUsers))
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
    public func followers(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readFollowers(name, configuration)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(Response.success(parsedUsers))
                }
            }
        }
    }

    /**
        Fetches the users following the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myFollowing(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readAuthenticatedFollowing(configuration)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(.success(parsedUsers))
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
    public func following(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<[User]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = FollowRouter.readFollowing(name, configuration)
        return router.loadJSON(session, expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUsers = json.map { User($0) }
                    completion(Response.success(parsedUsers))
                }
            }
        }
    }
}

enum FollowRouter: Router {
    case readAuthenticatedFollowers(Configuration)
    case readFollowers(String, Configuration)
    case readAuthenticatedFollowing(Configuration)
    case readFollowing(String, Configuration)

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var configuration: Configuration {
        switch self {
        case .readAuthenticatedFollowers(let config): return config
        case .readFollowers(_, let config): return config
        case .readAuthenticatedFollowing(let config): return config
        case .readFollowing(_, let config): return config
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedFollowers:
            return "user/followers"
        case .readFollowers(let username, _):
            return "users/\(username)/followers"
        case .readAuthenticatedFollowing:
            return "user/following"
        case .readFollowing(let username, _):
            return "users/\(username)/following"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
