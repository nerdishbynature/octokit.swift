import Foundation
import RequestKit

let githubBaseURL = "https://api.github.com"
let githubWebURL = "https://github.com"

public let OctoKitErrorDomain = "com.nerdishbynature.octokit"

public struct TokenConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let errorDomain = OctoKitErrorDomain

    public init(_ token: String? = nil, url: String = githubBaseURL) {
        apiEndpoint = url
        accessToken = token
    }
}

public struct OAuthConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?
    public let token: String
    public let secret: String
    public let scopes: [String]
    public let webEndpoint: String
    public let errorDomain = OctoKitErrorDomain

    public init(_ url: String = githubBaseURL, webURL: String = githubWebURL,
        token: String, secret: String, scopes: [String]) {
            apiEndpoint = url
            webEndpoint = webURL
            self.token = token
            self.secret = secret
            self.scopes = scopes
    }

    public func authenticate() -> URL? {
        return OAuthRouter.authorize(self).URLRequest?.url
    }

    public func authorize(_ session: RequestKitURLSession = URLSession.shared, code: String, completion: @escaping (_ config: TokenConfiguration) -> Void) {
        let request = OAuthRouter.accessToken(self, code).URLRequest
        if let request = request {
            let task = session.dataTask(with: request) { data, response, err in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        if let data = data, let string = String(data: data, encoding: .utf8) {
                            let accessToken = self.accessTokenFromResponse(string)
                            if let accessToken = accessToken {
                                let config = TokenConfiguration(accessToken, url: self.apiEndpoint)
                                completion(config)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    public func handleOpenURL(_ session: RequestKitURLSession = URLSession.shared, url: URL, completion: @escaping (_ config: TokenConfiguration) -> Void) {
        if let code = url.URLParameters["code"] {
            authorize(session, code: code) { (config) in
                completion(config)
            }
        }
    }

    public func accessTokenFromResponse(_ response: String) -> String? {
        let accessTokenParam = response.components(separatedBy: "&").first
        if let accessTokenParam = accessTokenParam {
            return accessTokenParam.components(separatedBy: "=").last
        }
        return nil
    }
}

enum OAuthRouter: Router {
    case authorize(OAuthConfiguration)
    case accessToken(OAuthConfiguration, String)

    var configuration: Configuration {
        switch self {
        case .authorize(let config): return config
        case .accessToken(let config, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .GET
        case .accessToken:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .authorize:
            return .url
        case .accessToken:
            return .form
        }
    }

    var path: String {
        switch self {
        case .authorize:
            return "login/oauth/authorize"
        case .accessToken:
            return "login/oauth/access_token"
        }
    }

    var params: [String: Any] {
        switch self {
        case .authorize(let config):
            let scope = (config.scopes as NSArray).componentsJoined(by: ",")
            return ["scope": scope, "client_id": config.token, "allow_signup": "false"]
        case .accessToken(let config, let code):
            return ["client_id": config.token, "client_secret": config.secret, "code": code]
        }
    }

    var URLRequest: Foundation.URLRequest? {
        switch self {
        case .authorize(let config):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        case .accessToken(let config, _):
            let url = URL(string: path, relativeTo: URL(string: config.webEndpoint)!)
            let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)
            return request(components!, parameters: params)
        }
    }
}
