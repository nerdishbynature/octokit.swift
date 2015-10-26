import Foundation

internal class Helper {
    internal class func stringFromFile(name: String) -> String? {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")
        if let path = path {
            let string = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            return string
        }
        return nil
    }

    internal class func JSONFromFile(name: String) -> AnyObject {
        let bundle = NSBundle(forClass: self)
        let path = bundle.pathForResource(name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let dict: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions.MutableContainers)
        return dict!
    }
}
