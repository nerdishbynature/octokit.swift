import Foundation

// MARK: request

public extension Octokit {
    public func postPublicKey(publicKey: String, title: String, completion: (response:Response<String>) -> Void) {
        postJSON(PublicKeyRouter.PostPublicKey(publicKey, title, self), expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let _ = json {
                    completion(response: Response.Success(Box(publicKey)))
                }
            }
        }
    }
}

public enum PublicKeyRouter: JSONPostRouter {
    case PostPublicKey(String, String, Octokit)

    public var method: HTTPMethod {
        switch self {
        case .PostPublicKey:
            return .POST
        }
    }

    public var encoding: HTTPEncoding {
        switch self {
        case .PostPublicKey:
            return .JSON
        }
    }

    public var path: String {
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
            return kit.request(self)
        }
    }
}
