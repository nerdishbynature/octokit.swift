import Foundation
import Alamofire

let githubBaseURL = "https://api.github.com"

public enum Server {
    case Github
    case Enterprise
}

public struct Configuration {
    public let apiEndpoint: String
    public let accessToken: String

    public init(_ url: String = githubBaseURL, token: String) {
        apiEndpoint = url
        accessToken = token
    }

    public var serverType: Server {
        get {
            return apiEndpoint == githubBaseURL ? .Github : .Enterprise
        }
    }
}

public struct Octokit {
    public let configuration: Configuration

    public init(_ config: Configuration = Configuration(token: "token")) {
        configuration = config
    }
}

public extension Octokit {
    public func user(name: String, completion: (user: User) -> Void) {
        Alamofire.request(Router.ReadUser(name, self)).responseJSON { (_, _, JSON, err) in
            if err == nil {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(user: parsedUser)
            }
        }
    }

    public func me(completion: (user: User) -> Void) {
        Alamofire.request(Router.ReadAuthenticatedUser(self)).responseJSON { (_, _, JSON, err) in
            if err == nil {
                let parsedUser = User(JSON as [String: AnyObject])
                completion(user: parsedUser)
            }
        }
    }
}

public enum Router: URLRequestConvertible {
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
            return encoding.encode(mutableURLRequest, parameters: ["access_token": kit.configuration.accessToken]).0
        case .ReadUser(let username, let kit):
            let URL = NSURL(string: kit.configuration.apiEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            return mutableURLRequest
        }
    }
}

public struct User {
    public let login: String

    init(_ json: [String: AnyObject]) {
        login = json["login"] as String
    }
}