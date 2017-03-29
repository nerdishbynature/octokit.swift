import Foundation
import RequestKit

// MARK: model

@objc open class User: NSObject {
    open let id: Int
    open var login: String?
    open var avatarURL: String?
    open var gravatarID: String?
    open var type: String?
    open var name: String?
    open var company: String?
    open var blog: String?
    open var location: String?
    open var email: String?
    open var numberOfPublicRepos: Int?
    open var numberOfPublicGists: Int?
    open var numberOfPrivateRepos: Int?

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
    public func user(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = UserRouter.readUser(name, self.configuration)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(Response.success(parsedUser))
                }
            }
        }
    }

    /**
        Fetches the authenticated user
        - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func me(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = UserRouter.readAuthenticatedUser(self.configuration)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(Response.success(parsedUser))
                }
            }
        }
    }
}

// MARK: Router

enum UserRouter: Router {
    case readAuthenticatedUser(Configuration)
    case readUser(String, Configuration)

    var configuration: Configuration {
        switch self {
        case .readAuthenticatedUser(let config): return config
        case .readUser(_, let config): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var path: String {
        switch self {
        case .readAuthenticatedUser:
            return "user"
        case .readUser(let username, _):
            return "users/\(username)"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
