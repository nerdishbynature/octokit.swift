import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: request

public extension Octokit {
    func postPublicKey(publicKey: String,
                       title: String,
                       completion: @escaping (_ response: Result<String, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PublicKeyRouter.postPublicKey(publicKey, title, configuration)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let _ = json {
                    completion(.success(publicKey))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func postPublicKey(publicKey: String, title: String) async throws -> String {
        let router = PublicKeyRouter.postPublicKey(publicKey, title, configuration)
        _ = try await router.postJSON(session, expectedResultType: [String: AnyObject].self)
        return publicKey
    }
    #endif
}

enum PublicKeyRouter: JSONPostRouter {
    case postPublicKey(String, String, Configuration)

    var configuration: Configuration {
        switch self {
        case let .postPublicKey(_, _, config): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postPublicKey:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postPublicKey:
            return .json
        }
    }

    var path: String {
        switch self {
        case .postPublicKey:
            return "user/keys"
        }
    }

    var params: [String: Any] {
        switch self {
        case let .postPublicKey(publicKey, title, _):
            return ["title": title, "key": publicKey]
        }
    }
}
