import Foundation

let errorDomain = "com.octokit.swift"

public enum Response<T> {
    case Success(T)
    case Failure(ErrorType)
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
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    }
}

public struct Octokit {
    public let configuration: TokenConfiguration

    public init(_ config: TokenConfiguration = TokenConfiguration()) {
        configuration = config
    }

    internal func request(router: Router) -> NSURLRequest? {
        let URLString = configuration.apiEndpoint.stringByAppendingURLPath(router.path)
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
            if parameters.keys.count > 0 {
                URLString = [URLString, Octokit.urlQuery(parameters).urlEncodedString() ?? ""].joinWithSeparator("?")
            }
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.HTTPMethod = router.method.rawValue
                return mutableURLRequest
            }
        case .FORM:
            let queryData = Octokit.urlQuery(parameters).dataUsingEncoding(NSUTF8StringEncoding)
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
        for key in parameters.keys.sort(<) {
            if let value = parameters[key] {
                components.append(key, value)
            }
        }

        return components.map{"\($0)=\($1)"}.joinWithSeparator("&")
    }

    internal func loadJSON<T>(router: Router, expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void) {
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
                    if let data = data {
                        do {
                            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? T
                            completion(json: JSON, error: nil)
                        } catch {
                            completion(json: nil, error: error)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    internal func postJSON<T>(router: JSONPostRouter, expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(router.params, options: NSJSONWritingOptions())
            if let request = router.URLRequest {
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
                        if let data = data {
                            do {
                                let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? T
                                completion(json: JSON, error: nil)
                            } catch {
                                completion(json: nil, error: error)
                            }
                        }
                    }
                }
                task.resume()
            }
        } catch {
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
