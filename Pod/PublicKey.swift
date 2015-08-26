import Foundation

// MARK: request

public extension Octokit {
    func postPublicKey(publicKey: String, title: String, completion: (response:Response<String>) -> Void) {
        postJSON(PublicKeyRouter.PostPublicKey(publicKey, title, self), expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    completion(response: Response.Success(Box(publicKey)))
                }
            }
        }
    }
}

public enum PublicKeyRouter: JSONPostRouter {
    case PostPublicKey(String, String, Octokit)

    var method: HTTPMethod {
        switch self {
        case .PostPublicKey:
            return .POST
        }
    }

    var path: String {
        switch self {
        case .PostPublicKey:
            return "user/keys"
        }
    }

    public var params: [String: String] {
        switch self {
        case .PostPublicKey(let publicKey, let title, _):
            return ["title": title, "key": publicKey]
        }
    }

    public var URLRequest: NSURLRequest? {
        switch self {
        case .PostPublicKey(_, _, let kit):
            return kit.request(path, method: method)
        }
    }
}
