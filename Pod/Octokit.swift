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

public enum HTTPEncoding: Int {
    case URL, FORM, JSON
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

    internal func request(router: Router) -> NSURLRequest? {
        var URLString = configuration.apiEndpoint.stringByAppendingURLPath(router.path)
        var parameters = router.encoding == .JSON ? [:] : router.params
        if let accessToken = configuration.accessToken {
            parameters["access_token"] = accessToken
        }
        return Octokit.request(URLString, router: router, parameters: parameters)
    }

    public static func request(urlString: String, router: Router, parameters: [String: String]) -> NSURLRequest? {
        var URLString = urlString
        switch router.encoding {
        case .URL, .JSON:
            if count(parameters.keys) > 0 {
                URLString = join("?", [URLString, Octokit.urlQuery(parameters).urlEncodedString() ?? ""])
            }
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.HTTPMethod = router.method.rawValue
                return mutableURLRequest
            }
        case .FORM:
            var queryData = Octokit.urlQuery(parameters).dataUsingEncoding(NSUTF8StringEncoding)
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                mutableURLRequest.HTTPBody = queryData
                mutableURLRequest.HTTPMethod = router.method.rawValue
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

    internal func postJSON<T>(router: JSONPostRouter, expectedResultType: T.Type, completion: (json: T?, error: NSError?) -> Void) {
        var error: NSError?
        if let request = router.URLRequest, data = NSJSONSerialization.dataWithJSONObject(router.params, options: .allZeros, error: &error) {
            let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data) { data, response, error in
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode != 201 {
                        let error = NSError(domain: errorDomain, code: response.statusCode, userInfo: nil)
                        completion(json: nil, error: error)
                        return
                    }
                }

                if let error = error {
                    completion(json: nil, error: error)
                } else {
                    var error: NSError?
                    if let JSON = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as? T {
                        completion(json: JSON, error: error)
                    }
                }
            }
            task.resume()
        }

        if let error = error {
            completion(json: nil, error: error)
        }
    }
}

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var URLRequest: NSURLRequest? { get }
    var encoding: HTTPEncoding { get }
    var params: [String: String] { get }
}

protocol JSONPostRouter: Router {
}
