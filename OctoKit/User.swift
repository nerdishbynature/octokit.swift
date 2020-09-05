import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    open var nodeId: String?
    open var url: String?
    open var htmlURL: String?
    open var followersURL: String?
    open var followingURL: String?
    open var gistsURL: String?
    open var starredURL: String?
    open var subscriptionsURL: String?
    open var reposURL: String?
    open var eventsURL: String?
    open var receivedEventsURL: String?
    open var siteAdmin: Bool?
    open var hireable: Bool?
    open var bio: String?
    open var twitterUsername: String?
    open var numberOfFollowers: Int?
    open var numberOfFollowing: Int?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var numberOfPrivateGists: Int?
    open var numberOfOwnPrivateRepos: Int?
    open var amountDiskUsage: Int?
    open var numberOfCollaborators: Int?
    open var twoFactorAuthenticationEnabled: Bool?
    open var subscriptionPlan: Plan?

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
        case nodeId = "node_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case numberOfFollowers = "followers"
        case numberOfFollowing = "following"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case numberOfPrivateGists = "private_gists"
        case numberOfOwnPrivateRepos = "owned_private_repos"
        case amountDiskUsage = "disk_usage"
        case numberOfCollaborators = "collaborators"
        case twoFactorAuthenticationEnabled = "two_factor_authentication"
        case subscriptionPlan = "plan"
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
    @discardableResult
    func user(_ session: RequestKitURLSession = URLSession.shared, name: String, completion: @escaping (_ response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
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
    @discardableResult
    func me(_ session: RequestKitURLSession = URLSession.shared, completion: @escaping (_ response: Response<User>) -> Void) -> URLSessionDataTaskProtocol? {
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
