import Octokit
import Alamofire
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
        login = json["login"] as String
        id = json["id"] as Int
        avatarURL = json["avatar_url"] as String
        gravatarID = json["gravatar_id"] as String
        type = json["type"] as String
        name = json["name"] as? String
        company = json["company"] as? String
        blog = json["blog"] as? String
        location = json["location"] as? String
        email = json["email"] as? String
        if let email = email {
            self.email = (email.utf16Count == 0) ? nil:email
        }
        numberOfPublicRepos = json["public_repos"] as? Int
        numberOfPublicGists = json["public_gists"] as? Int
        numberOfPrivateRepos = json["total_private_repos"] as? Int
    }
}

// MARK: request

public extension Octokit {
    public func user(name: String, completion: (response: Response<User>) -> Void) {
        Alamofire.request(UserRouter.ReadUser(name, self)).validate().responseJSON { (_, response, JSON, err) in
            if let err = err{
                completion(response: Response.Failure(self.parseError(err, response: response)))
            } else {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(response: Response.Success(Box(parsedUser)))
            }
        }
    }

    public func me(completion: (response: Response<User>) -> Void) {
        Alamofire.request(UserRouter.ReadAuthenticatedUser(self)).validate()
            .responseJSON { (_, response, JSON, err) in
            if let err = err {
                completion(response: Response.Failure(self.parseError(err, response: response)))
            } else {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(response: Response.Success(Box(parsedUser)))
            }
        }
    }
}

// MAKR: Router

public enum UserRouter: URLRequestConvertible {
    case ReadAuthenticatedUser(Octokit)
    case ReadUser(String, Octokit)

    var method: Alamofire.Method {
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

    public var URLRequest: NSURLRequest {
        switch self {
        case .ReadAuthenticatedUser(let kit):
            return kit.request(path, method: method)
        case .ReadUser(_, let kit):
            return kit.request(path, method: method)
        }
    }
}