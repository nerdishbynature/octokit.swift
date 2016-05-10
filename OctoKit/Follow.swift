import Foundation
import RequestKit

public extension Octokit {

    /**
        Fetches the followers of the authenticated user
        - parameter page: Current page for follower pagination. `1` by default.
        - parameter perPage: Number of followers per page. `100` by default.
        - parameter completion: Callback for the outcome of the fetch.
    */
    
    public func myFollowers(page: String = "1", perPage: String = "100", completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowers(configuration, page, perPage)
        router.loadJSON([[String: AnyObject]].self) { json, error in
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
        - parameter name: Name of the user
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func followers(name: String, completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadFollowers(name, configuration)
        router.loadJSON([[String: AnyObject]].self) { json, error in
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
        - parameter page: Current page for following pagination. `1` by default.
        - parameter perPage: Number of following per page. `100` by default.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myFollowing(page: String = "1", perPage: String = "100", completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowing(configuration, page, perPage)
        router.loadJSON([[String: AnyObject]].self) { json, error in
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
        - parameter name: The name of the user
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func following(name: String, completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadFollowing(name, configuration)
        router.loadJSON([[String: AnyObject]].self) { json, error in
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
    case ReadAuthenticatedFollowers(Configuration, String, String)
    case ReadFollowers(String, Configuration)
    case ReadAuthenticatedFollowing(Configuration, String, String)
    case ReadFollowing(String, Configuration)

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedFollowers(let config, _, _): return config
        case .ReadFollowers(_, let config): return config
        case .ReadAuthenticatedFollowing(let config, _, _): return config
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
        switch self {
        case .ReadAuthenticatedFollowers(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .ReadAuthenticatedFollowing(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        default:
            return [:]
        }
    }
}
