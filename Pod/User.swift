import Octokit
import Foundation

// MARK: model

public struct User {
    public let login: String
    public let id: Int
    public let avatarURL: String
    public let gravatarID: String
    public let type: String
    public let name: String?
    public let company: String?
    public let blog: String?
    public let location: String?
    public let email: String?
    public let numberOfPublicRepos: Int?
    public let numberOfPublicGists: Int?
    public let numberOfPrivateRepos: Int?

    public init(_ json: [String: AnyObject]) {
        login = json["login"] as! String
        id = json["id"] as! Int
        avatarURL = json["avatar_url"] as! String
        gravatarID = json["gravatar_id"] as! String
        type = json["type"] as! String
        name = json["name"] as? String
        company = json["company"] as? String
        blog = json["blog"] as? String
        location = json["location"] as? String
        email = json["email"] as? String
        numberOfPublicRepos = json["public_repos"] as? Int
        numberOfPublicGists = json["public_gists"] as? Int
        numberOfPrivateRepos = json["total_private_repos"] as? Int
    }
}

// MARK: request

public extension Octokit {
    public func user(name: String, completion: (response: Response<User>) -> Void) {
        let request = UserRouter.ReadUser(name, self).URLRequest
        loadJSON(request, expectedResultType: [String: AnyObject].self) { json, error in
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
        let request = UserRouter.ReadAuthenticatedUser(self).URLRequest
        loadJSON(request, expectedResultType: [String: AnyObject].self) { json, error in
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

public enum UserRouter {
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