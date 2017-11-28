#if os(OSX)
    import Cocoa
    typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
    typealias Color = UIColor
#endif

extension Color {
    @objc convenience init?(hexTriplet hex: String) {
        var hexChars = Substring(hex)
        let red = Int(String(hex.prefix(2)), radix: 16)
        hexChars = hexChars.dropFirst(2)
        let green = Int(String(hexChars.prefix(2)), radix: 16)
        hexChars = hexChars.dropFirst(2)
        let blue = Int(String(hexChars), radix: 16)
        if let red = red, let green = green, let blue = blue {
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
        } else {
            return nil
        }
    }
}

@objc open class Label: NSObject {
    @objc open var url: URL?
    @objc open var name: String?
    #if os(OSX)
        open var color: NSColor?
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        @objc public var color: UIColor?
    #endif
    
    @objc public init(_ json: [String: AnyObject]) {
        if let urlString = json["url"] as? String, let url = URL(string: urlString) {
            self.url = url
        }
        name = json["name"] as? String
        if let colorString = json["color"] as? String {
            color = Color(hexTriplet: colorString)
        }
    }
}
