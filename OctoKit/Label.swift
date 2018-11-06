import Foundation

#if os(Linux)
open class Label: Codable {
    open var url: URL?
    open var name: String?
    open var color: String?
}
#else
@objc open class Label: NSObject, Codable {
    @objc open var url: URL?
    @objc open var name: String?
    @objc open var color: String?
}
#endif
