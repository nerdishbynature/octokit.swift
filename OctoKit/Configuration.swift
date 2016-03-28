import Foundation
import RequestKit

let githubBaseURL = "https://api.github.com"
let githubWebURL = "https://github.com"

public struct TokenConfiguration: Configuration {
    public var apiEndpoint: String
    public var accessToken: String?

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

    public init(_ url: String = githubBaseURL, webURL: String = githubWebURL,
        token: String, secret: String, scopes: [String]) {
            apiEndpoint = url
            webEndpoint = webURL
            self.token = token
            self.secret = secret
            self.scopes = scopes
    }

    public func authenticate() -> NSURL? {
        return OAuthRouter.Authorize(self).URLRequest?.URL
    }

    public func authorize(session: RequestKitURLSession = NSURLSession.sharedSession(), code: String, completion: (config: TokenConfiguration) -> Void) {
        let request = OAuthRouter.AccessToken(self, code).URLRequest
        if let request = request {
            let task = session.dataTaskWithRequest(request) { data, response, err in
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode != 200 {
                        return
                    } else {
                        if let data = data, string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                            let accessToken = self.accessTokenFromResponse(string)
                            if let accessToken = accessToken {
                                let config = TokenConfiguration(accessToken, url: self.apiEndpoint)
                                completion(config: config)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    public func handleOpenURL(url: NSURL, completion: (config: TokenConfiguration) -> Void) {
        if let code = url.absoluteString.componentsSeparatedByString("=").last {
            authorize(code: code) { (config) in
                completion(config: config)
            }
        }
    }

    public func accessTokenFromResponse(response: String) -> String? {
        let accessTokenParam = response.componentsSeparatedByString("&").first
        if let accessTokenParam = accessTokenParam {
            return accessTokenParam.componentsSeparatedByString("=").last
        }
        return nil
    }
}

enum OAuthRouter: Router {
    case Authorize(OAuthConfiguration)
    case AccessToken(OAuthConfiguration, String)

    var configuration: Configuration {
        switch self {
        case .Authorize(let config): return config
        case .AccessToken(let config, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .Authorize:
            return .GET
        case .AccessToken:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .Authorize:
            return .URL
        case .AccessToken:
            return .FORM
        }
    }

    var path: String {
        switch self {
        case .Authorize:
            return "login/oauth/authorize"
        case .AccessToken:
            return "login/oauth/access_token"
        }
    }

    var params: [String: String] {
        switch self {
        case .Authorize(let config):
            let scope = (config.scopes as NSArray).componentsJoinedByString(",")
            return ["scope": scope, "client_id": config.token, "allow_signup": "false"]
        case .AccessToken(let config, let code):
            return ["client_id": config.token, "client_secret": config.secret, "code": code]
        }
    }

    var URLRequest: NSURLRequest? {
        switch self {
        case .Authorize(let config):
            let URLString = config.webEndpoint.stringByAppendingURLPath(path)
            return request(URLString, parameters: params)
        case .AccessToken(let config, _):
            let URLString = config.webEndpoint.stringByAppendingURLPath(path)
            return request(URLString, parameters: params)
        }
    }
}
