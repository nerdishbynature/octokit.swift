import Foundation
import OctoKit

internal class Helper {
    internal class func stringFromFile(_ name: String) -> String? {
        let path = jsonFilePath(resourceName: name)
        
        let string = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return string
    }

    internal class func JSONFromFile(_ name: String) -> Any {
        let path = jsonFilePath(resourceName: name)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let dict: Any? = try? JSONSerialization.jsonObject(with: data,
        options: JSONSerialization.ReadingOptions.mutableContainers)
        return dict!
    }

    internal class func codableFromFile<T>(_ name: String, type: T.Type) -> T where T: Codable {
        var path: String
        let bundlePath = jsonFilePath(resourceName: name)
        if FileManager.default.fileExists(atPath: bundlePath) {
            path = bundlePath
        }
        else {
            let bundle = Bundle(path: "OctoKitTests/Fixtures")
            path = bundle!.path(forResource: name, ofType: "json")!
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try! decoder.decode(T.self, from: data)
    }
    
    private class func jsonFilePath(resourceName: String) -> String {
        #if os(Linux)
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let path = currentDirectoryPath + "/Tests/OctoKitTests/" + resourceName + ".json"
        #else
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: resourceName, ofType: "json")!
        #endif
        
        return path
    }
}
