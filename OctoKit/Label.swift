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

@objc open class Label: NSObject, Codable {
    @objc open var url: URL?
    @objc open var name: String?
    @objc open var color: String?
}
