import Alamofire

let githubBaseURL = "https://api.github.com"
let githubWebURL = "https://github.com"

public protocol OctokitConfiguration {
    var apiEndpoint: String { get }
    var accessToken: String? { get }
}

public struct TokenConfiguration: OctokitConfiguration {
    public var apiEndpoint: String
    public var accessToken: String?

    public init(_ token: String? = nil, url: String = githubBaseURL) {
        apiEndpoint = url
        accessToken = token
    }
}

public struct OAuthConfiguration: OctokitConfiguration {
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

    public func authenticate() {
        let url = OAuthRouter.Authorize(self).URLRequest.URL
        UIApplication.sharedApplication().openURL(url!)
    }

    public func authorize(code: String, completion: (config: TokenConfiguration) -> Void) {

        Alamofire.request(OAuthRouter.AccessToken(self, code)).validate().responseString(encoding: NSUTF8StringEncoding, completionHandler:
            { (_, response, string, error) in
                if error == nil {
                    if let string = string {
                        let accessToken = self.accessTokenFromResponse(string)
                        if let accessToken = accessToken {
                            let config = TokenConfiguration(accessToken, url: self.apiEndpoint)
                            completion(config: config)
                        }
                    }
                } else {
                    println(error)
                }
            })
    }

    public func handleOpenURL(url: NSURL, completion: (config: TokenConfiguration) -> Void) {
        if let code = url.absoluteString?.componentsSeparatedByString("=").last {
            authorize(code) { (config) in
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

public enum OAuthRouter: URLRequestConvertible {
    case Authorize(OAuthConfiguration)
    case AccessToken(OAuthConfiguration, String)

    var method: Alamofire.Method {
        switch self {
        case .Authorize:
            return .GET
        case .AccessToken:
            return .POST
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

    var params: [String: AnyObject] {
        switch self {
        case .Authorize(let config):
            let scope = (config.scopes as NSArray).componentsJoinedByString(",")
            return ["scope": scope, "client_id": config.token]
        case .AccessToken(let config, let code):
            return ["client_id": config.token, "client_secret": config.secret, "code": code]
        }
    }

    var mutableURLRequest: NSMutableURLRequest {
        switch self {
        case .Authorize(let config):
            let URL = NSURL(string: config.webEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            return mutableURLRequest
        case .AccessToken(let config, _):
            let URL = NSURL(string: config.webEndpoint)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            return mutableURLRequest
        }
    }

    public var URLRequest: NSURLRequest {
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
    }
}
