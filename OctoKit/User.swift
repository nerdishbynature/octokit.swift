import Foundation
import RequestKit

// MARK: model
open class User: Codable {
    open internal(set) var id: Int = -1
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case type
        case name
        case company
        case blog
        case location
        case email
        case numberOfPublicRepos = "public_repos"
        case numberOfPublicGists = "public_gists"
        case numberOfPrivateRepos = "total_private_repos"
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
        return router.load(session, expectedResultType: User.self) { user, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let user = user {
                    completion(Response.success(user))
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
        return router.load(session, expectedResultType: User.self) { user, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let user = user {
                    completion(Response.success(user))
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
