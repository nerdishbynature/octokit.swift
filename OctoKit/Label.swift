#if os(OSX)
    import Cocoa
    typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
    typealias Color = UIColor
#endif

extension Color {
    convenience init?(hexTriplet hex: String) {
        var hexChars = hex.characters
        let red = Int(String(hexChars.prefix(2)), radix: 16)
        hexChars = hexChars.dropFirst(2)
        let green = Int(String(hexChars.prefix(2)), radix: 16)
        hexChars = hexChars.dropFirst(2)
        let blue = Int(String(hexChars), radix: 16)
        if let red = red, green = green, blue = blue {
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
        } else {
            return nil
        }
    }
}

@objc public class Label: NSObject {
    public var url: NSURL?
    public var name: String?
    #if os(OSX)
        public var color: NSColor?
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        public var color: UIColor?
    #endif
    
    public init(_ json: [String: AnyObject]) {
        if let urlString = json["url"] as? String, url = NSURL(string: urlString) {
            self.url = url
        }
        name = json["name"] as? String
        if let colorString = json["color"] as? String {
            color = Color(hexTriplet: colorString)
        }
    }
}
