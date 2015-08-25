import Foundation

// MARK: model

public struct User {
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
    public func user(name: String, completion: (response: Response<User>) -> Void) {
        loadJSON(UserRouter.ReadUser(name, self), expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(response: Response.Success(Box(parsedUser)))
                }
            }
        }
    }

    public func me(completion: (response: Response<User>) -> Void) {
        loadJSON(UserRouter.ReadAuthenticatedUser(self), expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedUser = User(json)
                    completion(response: Response.Success(Box(parsedUser)))
                }
            }
        }
    }
}

// MAKR: Router

public enum UserRouter: Router {
    case ReadAuthenticatedUser(Octokit)
    case ReadUser(String, Octokit)

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedUser:
            return "user"
        case .ReadUser(let username, _):
            return "users/\(username)"
        }
    }

    public var URLRequest: NSURLRequest? {
        switch self {
        case .ReadAuthenticatedUser(let kit):
            return kit.request(path, method: method)
        case .ReadUser(_, let kit):
            return kit.request(path, method: method)
        }
    }
}