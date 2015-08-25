import Foundation

let errorDomain = "com.octokit.swift"

final public class Box<T> {
    public let unbox: T
    public init(_ value: T) { self.unbox = value }
}

public enum Response<T> {
    case Success(Box<T>)
    case Failure(NSError)
}

public enum HTTPMethod: String {
    case GET = "GET", POST = "POST"
}

extension String {
    func stringByAppendingURLPath(path: String) -> String {
        return path.hasPrefix("/") ? self + path : self + "/" + path
    }

    func urlEncodedString() -> String? {
        var originalString = "test/test"
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    }
}

public struct Octokit {
    public let configuration: TokenConfiguration

    public init(_ config: TokenConfiguration = TokenConfiguration()) {
        configuration = config
    }

    internal func request(path: String, method: HTTPMethod) -> NSURLRequest? {
        var URLString = configuration.apiEndpoint.stringByAppendingURLPath(path)
        var parameters: [String: String]?
        if let accessToken = configuration.accessToken {
            parameters = ["access_token": accessToken]
        }
        return Octokit.request(URLString, method: method, parameters: parameters)
    }

    public static func request(string: String, method: HTTPMethod, parameters: [String: String]?) -> NSURLRequest? {
        var URLString = string
        switch method {
        case .GET:
            if let parameters = parameters {
                URLString = join("?", [URLString, Octokit.urlQuery(parameters).urlEncodedString() ?? ""])
            }

            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.HTTPMethod = method.rawValue
                return mutableURLRequest
            }
        case .POST:
            var queryData: NSData? = nil
            if let parameters = parameters {
                queryData = Octokit.urlQuery(parameters).dataUsingEncoding(NSUTF8StringEncoding)
            }

            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                mutableURLRequest.HTTPBody = queryData
                mutableURLRequest.HTTPMethod = method.rawValue
                return mutableURLRequest
            }
        }

        return nil
    }

     public static func urlQuery(parameters: [String: String]) -> String {
        var components: [(String, String)] = []
        for key in sorted(parameters.keys, <) {
            if let value = parameters[key] {
                components.append(key, value)
            }
        }

        return join("&", components.map{"\($0)=\($1)"})
    }

    internal func loadJSON<T>(router: Router, expectedResultType: T.Type, completion: (json: T?, error: NSError?) -> Void) {
        if let request = router.URLRequest {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, err in
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode != 200 {
                        let error = NSError(domain: errorDomain, code: response.statusCode, userInfo: nil)
                        completion(json: nil, error: error)
                        return
                    }
                }

                if let err = err {
                    completion(json: nil, error: err)
                } else {
                    var error: NSError?
                    if let JSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as? T {
                        completion(json: JSON, error: error)
                    }
                }
            }
            task.resume()
        }
    }
}

protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var URLRequest: NSURLRequest? { get }
}
