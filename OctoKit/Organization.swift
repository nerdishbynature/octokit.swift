import Foundation

open class Organization: Codable {
    public let login: String
    public let id: Int
    public let node_id: String
    public let avatar_url: String
    public let url: String
    public let html_url: String
    public let repos_url: String
    public let events_url: String
    public let type: String

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case url
        case html_url
        case repos_url
        case events_url
        case type
    }
}
