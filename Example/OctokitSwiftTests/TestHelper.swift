import Foundation

internal class Helper {
    internal class func stringFromFile(name: String) -> String? {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")
        if let path = path {
            let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            return string
        }
        return nil
    }

    internal class func JSONFromFile(name: String) -> [String: AnyObject] {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let dict = NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions.MutableContainers, error: nil) as [String: AnyObject]
        return dict
    }
}