import Foundation
import RequestKit

public extension Octokit {

    /**
        Fetches all the starred repositories for a user
        - parameter name: The user who starred repositories.
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func stars(name: String, completion: (response: Response<[Repository]>) -> Void) {
        let router = StarsRouter.ReadStars(name, configuration)
        router.loadJSON(expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedStars = json.map { Repository($0) }
                    completion(response: Response.Success(parsedStars))
                }
            }
        }
    }

    /**
        Fetches all the starred repositories for the authenticated user
        - parameter completion: Callback for the outcome of the fetch.
    */
    public func myStars(completion: (response: Response<[Repository]>) -> Void) {
        let router = StarsRouter.ReadAuthenticatedStars(configuration)
        router.loadJSON(expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedStars = json.map { Repository($0) }
                    completion(response: Response.Success(parsedStars))
                }
            }
        }
    }
}

enum StarsRouter: Router {
    case ReadAuthenticatedStars(Configuration)
    case ReadStars(String, Configuration)
    var method: HTTPMethod {
        return .GET
    }

    var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedStars(let config): return config
        case .ReadStars(_, let config): return config
        }
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var path: String {
        switch self {
        case .ReadAuthenticatedStars:
            return "user/starred"
        case .ReadStars(let username, _):
            return "users/\(username)/starred"
        }
    }

    var params: [String: String] {
        return [:]
    }

    var URLRequest: NSURLRequest? {
        return request()
    }
}
