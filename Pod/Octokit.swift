import Foundation
import Alamofire

let errorDomain = "com.octokit.swift"

final public class Box<T> {
    public let unbox: T
    public init(_ value: T) { self.unbox = value }
}

public enum Response<T> {
    case Success(Box<T>)
    case Failure(NSError)
}

public struct Octokit {
    public let configuration: TokenConfiguration

    public init(_ config: TokenConfiguration = TokenConfiguration()) {
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

    internal func request(path: String, method: Alamofire.Method) -> NSURLRequest {
        let URL = NSURL(string: configuration.apiEndpoint)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        var parameters: [String: AnyObject]?
        if let accessToken = configuration.accessToken {
            parameters = ["access_token": accessToken]
        }
        return encoding.encode(mutableURLRequest, parameters: parameters).0
    }
}
