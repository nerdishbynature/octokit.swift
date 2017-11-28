import Foundation

internal class Helper {
    internal class func stringFromFile(_ name: String) -> String? {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")
        if let path = path {
            let string = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return string
        }
        return nil
    }

    internal class func JSONFromFile(_ name: String) -> Any {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let dict: Any? = try? JSONSerialization.jsonObject(with: data,
        options: JSONSerialization.ReadingOptions.mutableContainers)
        return dict!
    }

    internal class func codableFromFile<T>(_ name: String, type: T.Type) -> T where T: Codable {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return try! JSONDecoder().decode(T.self, from: data)
    }
}
