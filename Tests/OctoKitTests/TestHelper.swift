import Foundation
import OctoKit

internal class Helper {
    internal class func stringFromFile(_ name: String) -> String? {
        let path = jsonFilePath(for: name)
        return try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }

    internal class func JSONFromFile(_ name: String) -> Any {
        let path = jsonFilePath(for: name)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let dict: Any? = try? JSONSerialization.jsonObject(with: data,
        options: JSONSerialization.ReadingOptions.mutableContainers)
        return dict!
    }

    internal class func codableFromFile<T>(_ name: String, type: T.Type) -> T where T: Codable {
        let path = jsonFilePath(for: name)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try! decoder.decode(T.self, from: data)
    }
    
    internal class func makeAuthHeader(username: String, password: String) -> [String: String] {
        let token = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
        return [
            "Authorization": "Basic \(token)"
        ]
    }
    
    private class func jsonFilePath(for resourceName: String) -> String {
        let baseURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
        let bundlePath = baseURL.appendingPathComponent("\(resourceName).json").path

        if FileManager.default.fileExists(atPath: bundlePath) {
            return bundlePath
        } else {
            return baseURL
                .appendingPathComponent("Fixtures")
                .appendingPathComponent("\(resourceName).json")
                .path
        }
    }
}
