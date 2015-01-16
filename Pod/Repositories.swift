import Octokit
import Alamofire
import Foundation

// MARK: model

public struct Repository {
    public let owner: User
    public let name: String

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as [String: AnyObject])
        name = json["name"] as String
    }
}

// MARK: request

public extension Octokit {
    public func repositories(completion: (response: Response<[Repository]>) -> Void) {
        Alamofire.request(RepositoryRouter.ReadRepositories(self)).validate().responseJSON { (_, response, JSON, err) in
            if let err = err{
                completion(response: Response.Failure(self.parseError(err, response: response)))
            } else {
                let jsonRepos = JSON as [[String: AnyObject]]
                let repos = jsonRepos.map({ json -> Repository in
                    return Repository(json)
                })
                completion(response: Response.Success(Box(repos)))
            }
        }
    }
}

// MARK: Router

public enum RepositoryRouter: URLRequestConvertible {
    case ReadRepositories(Octokit)

    var method: Alamofire.Method {
        switch self {
        case .ReadRepositories:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .ReadRepositories:
            return "/user/repos"
        }
    }

    public var URLRequest: NSURLRequest {
        switch self {
        case .ReadRepositories(let kit):
            let URL = NSURL(string: kit.configuration.apiEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            let encoding = Alamofire.ParameterEncoding.URL
            var parameters: [String: AnyObject]?
            if let accessToken = kit.configuration.accessToken {
                parameters = ["access_token": accessToken]
            }
            return encoding.encode(mutableURLRequest, parameters: parameters).0
        }
    }
}