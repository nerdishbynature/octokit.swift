import Foundation

internal class Helper {
    internal class func jsonFromFile(name: String) -> String? {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")
        if let path = path {
            let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            return string
        }
        return nil
    }
}