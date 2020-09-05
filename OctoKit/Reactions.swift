/// `Reactions` are available on all Issues and Pull Requests.
///
/// `Reactions` are in general available as an object in some API response,
/// there is no API available directly for `Reactions`.
public struct Reactions: Codable {
    public let totalCount: Int?
    public let plus1: Int?
    public let minus1: Int?
    public let laugh: Int?
    public let confused: Int?
    public let heart: Int?
    public let hooray: Int?
    public let rocket: Int?
    public let eyes: Int?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case laugh, confused, heart, hooray, url, eyes, rocket
        case totalCount = "total_count"
        case plus1 = "+1"
        case minus1 = "-1"
    }
}
