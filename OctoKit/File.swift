
import Foundation

public typealias FileDict = [String: File]
public typealias Files = [FileDict]

open class File: Codable {
    open private(set) var id: Int = -1
    open var rawURL: URL?
    open var filename: String?
    open var type: String?
    open var language: String?
    open var size: Int?
    
    enum CodingKeys: String, CodingKey {
        case rawURL = "raw_url"
        case filename
        case type
        case language
        case size
    }
    
}
