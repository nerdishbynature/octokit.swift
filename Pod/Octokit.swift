import Foundation
import Alamofire

let errorDomain = "com.octokit.swift"

public struct Octokit {
    public let configuration: TokenConfiguration

    public init(_ config: TokenConfiguration = TokenConfiguration(token: "token")) {
        configuration = config
    }

    internal func parseError(err: NSError, response: NSHTTPURLResponse?) -> NSError {
        if let response = response {
            let error = NSError(domain: errorDomain, code: response.statusCode, userInfo: nil)
            return error
        } else {
            return err
        }
    }
}
