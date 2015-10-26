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

public extension String {
    func stringByAppendingURLPath(path: String) -> String {
        return path.hasPrefix("/") ? self + path : self + "/" + path
    }

    func urlEncodedString() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    }
}

public protocol Configuration {
    var apiEndpoint: String { get }
    var accessToken: String? { get }
}

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: HTTPEncoding { get }
    var params: [String: String] { get }
    var configuration: Configuration { get }

    func urlQuery(parameters: [String: String]) -> String
    func request(urlString: String, parameters: [String: String]) -> NSURLRequest?
    func loadJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void)
    func request() -> NSURLRequest?
}

public extension Router {
    public func request() -> NSURLRequest? {
        let URLString = configuration.apiEndpoint.stringByAppendingURLPath(path)
        var parameters = encoding == .JSON ? [:] : params
        if let accessToken = configuration.accessToken {
            parameters["access_token"] = accessToken
        }
        return request(URLString, parameters: parameters)
    }

    public func urlQuery(parameters: [String: String]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sort(<) {
            if let value = parameters[key] {
                components.append(key, value)
            }
        }

        return components.map{"\($0)=\($1)"}.joinWithSeparator("&")
    }

    public func request(urlString: String, parameters: [String: String]) -> NSURLRequest? {
        var URLString = urlString
        switch encoding {
        case .URL, .JSON:
            if parameters.keys.count > 0 {
                URLString = [URLString, urlQuery(parameters).urlEncodedString() ?? ""].joinWithSeparator("?")
            }
            if let URL = NSURL(string: URLString) {
                let mutableURLRequest = NSMutableURLRequest(URL: URL)
                mutableURLRequest.HTTPMethod = method.rawValue
                return mutableURLRequest
            }
        case .FORM:
            let queryData = urlQuery(parameters).dataUsingEncoding(NSUTF8StringEncoding)
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

    func loadJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void) {
        if let request = request() {
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
}

public protocol JSONPostRouter: Router {
    func postJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void)
}

public extension JSONPostRouter {
    public func postJSON<T>(expectedResultType: T.Type, completion: (json: T?, error: ErrorType?) -> Void) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            if let request = request() {
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

