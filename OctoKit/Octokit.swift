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
}
