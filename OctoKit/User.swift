import Foundation
import RequestKit

// MARK: model

@objc public class User: NSObject {
    public let id: Int
    public var login: String?
    public var avatarURL: String?
    public var gravatarID: String?
    public var type: String?
    public var name: String?
    public var company: String?
    public var blog: String?
    public var location: String?
    public var email: String?
    public var numberOfPublicRepos: Int?
    public var numberOfPublicGists: Int?
    public var numberOfPrivateRepos: Int?

    public init(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            self.id = id
            login = json["login"] as? String
            avatarURL = json["avatar_url"] as? String
            gravatarID = json["gravatar_id"] as? String
            type = json["type"] as? String
            name = json["name"] as? String
            company = json["company"] as? String
            blog = json["blog"] as? String
            location = json["location"] as? String
            email = json["email"] as? String
            numberOfPublicRepos = json["public_repos"] as? Int
            numberOfPublicGists = json["public_gists"] as? Int
            numberOfPrivateRepos = json["total_private_repos"] as? Int
        } else {
            id = -1
        }
    }
}

// MARK: request

public extension Octokit {

    /**
        Fetches a user or organization
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter name: The name of the user or organization.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func user(session: RequestKitURLSession = NSURLSession.sharedSession(), name: String, completion: (response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = UserRouter.ReadUser(name, self.configuration)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(response: Response.Success(parsedUser))
                }
            }
        }
    }

    /**
        Fetches the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func me(session: RequestKitURLSession = NSURLSession.sharedSession(), completion: (response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = UserRouter.ReadAuthenticatedUser(self.configuration)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(response: Response.Success(parsedUser))
                }
            }
        }
    }
}

// MARK: Router

enum UserRouter: Router {
    case ReadAuthenticatedUser(Configuration)
    case ReadUser(String, Configuration)

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedUser(let config): return config
        case .ReadUser(_, let config): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedUser:
            return "user"
        case .ReadUser(let username, _):
            return "users/\(username)"
        }
    }

    var params: [String: AnyObject] {
        return [:]
    }
}
