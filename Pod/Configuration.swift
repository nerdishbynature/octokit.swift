let githubBaseURL = "https://api.github.com"

public enum Server {
    case Github
    case Enterprise
}

public protocol OctokitConfiguration {
    var apiEndpoint: String { get }
    var accessToken: String? { get }
}

public struct TokenConfiguration: OctokitConfiguration {
    public var apiEndpoint: String
    public var accessToken: String?

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

public struct OAuthConfiguration: OctokitConfiguration {
    public var apiEndpoint: String
    public var accessToken: String?
    public var token: String
    public var secret: String

    public init(_ url: String = githubBaseURL, token: String, secret: String) {
        apiEndpoint = url
        self.token = token
        self.secret = secret
    }
}