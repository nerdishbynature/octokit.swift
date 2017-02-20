import Foundation

internal extension URL {
    var URLParameters: [String: String] {
        let stringParams = absoluteString.components(separatedBy: "?").last
        let params = stringParams?.components(separatedBy: "&")
        var returnParams: [String: String] = [:]
        if let params = params {
            for param in params {
                let keyValue = param.components(separatedBy: "=")
                if let key = keyValue.first, let value = keyValue.last {
                    returnParams[key] = value
                }
            }
        }
        return returnParams
    }
}
