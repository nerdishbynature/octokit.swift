import Foundation

public extension Octokit {
    public func stars(name: String, completion: (response: Response<[Repository]>) -> Void) {
        loadJSON(StarsRouter.ReadStars(name, self), expectedResultType: [[String: AnyObject]].self) { json, error in
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

    public func myStars(completion: (response: Response<[Repository]>) -> Void) {
        loadJSON(StarsRouter.ReadAuthenticatedStars(self), expectedResultType: [[String: AnyObject]].self) { json, error in
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

public enum StarsRouter: Router {
    case ReadAuthenticatedStars(Octokit)
    case ReadStars(String, Octokit)
    public var method: HTTPMethod {
        return .GET
    }

    public var encoding: HTTPEncoding {
        return .URL
    }

    public var path: String {
        switch self {
        case .ReadAuthenticatedStars:
            return "user/starred"
        case .ReadStars(let username, _):
            return "users/\(username)/starred"
        }
    }

    public var params: [String: String] {
        return [:]
    }

    public var URLRequest: NSURLRequest? {
        switch self {
        case .ReadAuthenticatedStars(let kit):
            return kit.request(self)
        case .ReadStars(_, let kit):
            return kit.request(self)
        }
    }
}
