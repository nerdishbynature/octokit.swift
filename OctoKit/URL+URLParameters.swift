import Foundation

internal extension URL {
    var URLParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return [:] }
        var params = [String: String]()
        components.queryItems?.forEach { queryItem in
            params[queryItem.name] = queryItem.value
        }
        return params
    }
}
