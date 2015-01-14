import Octokit
import Alamofire

// MARK: model

public struct User {
    public let login: String

    init(_ json: [String: AnyObject]) {
        login = json["login"] as String
    }
}

// MARK: request

public extension Octokit {
    public func user(name: String, completion: (user: User) -> Void) {
        Alamofire.request(UserRouter.ReadUser(name, self)).validate().responseJSON { (_, _, JSON, err) in
            if err == nil {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(user: parsedUser)
            }
        }
    }

    public func me(completion: (user: User) -> Void) {
        Alamofire.request(UserRouter.ReadAuthenticatedUser(self)).validate().responseJSON { (_, _, JSON, err) in
            if err == nil {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(user: parsedUser)
            }
        }
    }
}

// MAKR: Router

public enum UserRouter: URLRequestConvertible {
    case ReadAuthenticatedUser(Octokit)
    case ReadUser(String, Octokit)

    var method: Alamofire.Method {
        switch self {
        case .ReadAuthenticatedUser:
            return .GET
        case .ReadUser:
            return .GET
        }
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
            let URL = NSURL(string: kit.configuration.apiEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            let encoding = Alamofire.ParameterEncoding.URL
            var parameters: [String: AnyObject]?
            if let accessToken = kit.configuration.accessToken {
                parameters = ["access_token": accessToken]
            }
            return encoding.encode(mutableURLRequest, parameters: parameters).0
        case .ReadUser(let username, let kit):
            let URL = NSURL(string: kit.configuration.apiEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            return mutableURLRequest
        }
    }
}