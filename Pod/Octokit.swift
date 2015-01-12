import Foundation

let githubBaseURL = "https://api.github.com"

public enum Server {
    case Github
    case Enterprise
}

public struct Configuration {
    public let apiEndpoint: String

    public init(_ url: String = githubBaseURL) {
        apiEndpoint = url
    }

    public var serverType: Server {
        get {
            return apiEndpoint == githubBaseURL ? .Github : .Enterprise
        }
    }

    public var accessToken: String {
        get {
            if let token = Keychain.load() {
                return token
            } else {
                return ""
            }
        }
        set {
            Keychain.save(newValue)
        }
    }
}

public struct Octokit {
    let configuration: Configuration

    public init(_ config: Configuration = Configuration()) {
        configuration = config
    }

    public var baseURL: String {
        get {
            return configuration.apiEndpoint
        }
    }
}