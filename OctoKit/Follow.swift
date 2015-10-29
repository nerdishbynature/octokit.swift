import Foundation
import RequestKit

public extension Octokit {
    public func myFollowers(completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowers(configuration)
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

    public func myFollowing(completion: (response: Response<[User]>) -> Void) {
        let router = FollowRouter.ReadAuthenticatedFollowing(configuration)
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

public enum FollowRouter: Router {
    case ReadAuthenticatedFollowers(Configuration)
    case ReadFollowers(String, Configuration)
    case ReadAuthenticatedFollowing(Configuration)
    case ReadFollowing(String, Configuration)

    public var method: HTTPMethod {
        return .GET
    }

    public var encoding: HTTPEncoding {
        return .URL
    }

    public var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedFollowers(let config): return config
        case .ReadFollowers(_, let config): return config
        case .ReadAuthenticatedFollowing(let config): return config
        case .ReadFollowing(_, let config): return config
        }
    }

    public var path: String {
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

    public var params: [String: String] {
        return [:]
    }

    public var URLRequest: NSURLRequest? {
        return request()
    }
}
