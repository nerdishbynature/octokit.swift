import Foundation

@objc open class Milestone: NSObject, Codable {
    @objc open var url: URL?
    @objc open var htmlURL: URL?
    @objc open var labelsURL: URL?
    @objc open private(set) var id: Int = -1
    open var number: Int?
    open var state: Openness?
    @objc open var title: String?
    @objc open var milestoneDescription: String?
    @objc open var creator: User?
    open var openIssues: Int?
    open var closedIssues: Int?
    @objc open var createdAt: Date?
    @objc open var updatedAt: Date?
    @objc open var closedAt: Date?
    @objc open var dueOn: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case htmlURL = "html_url"
        case labelsURL = "labels_url"
        case number
        case state
        case title
        case milestoneDescription = "description"
        case creator
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case dueOn = "due_on"
    }
}
