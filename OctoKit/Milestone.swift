import Foundation

open class Milestone: Codable {
    open var url: URL?
    open var htmlURL: URL?
    open var labelsURL: URL?
    open private(set) var id: Int
    open var number: Int?
    open var state: Openness?
    open var title: String?
    open var milestoneDescription: String?
    open var creator: User?
    open var openIssues: Int?
    open var closedIssues: Int?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedAt: Date?
    open var dueOn: Date?

    public init(url: URL? = nil,
                htmlURL: URL? = nil,
                labelsURL: URL? = nil,
                id: Int = -1,
                number: Int? = nil,
                state: Openness? = nil,
                title: String? = nil,
                milestoneDescription: String? = nil,
                creator: User? = nil,
                openIssues: Int? = nil,
                closedIssues: Int? = nil,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                closedAt: Date? = nil,
                dueOn: Date? = nil) {
        self.url = url
        self.htmlURL = htmlURL
        self.labelsURL = labelsURL
        self.id = id
        self.number = number
        self.state = state
        self.title = title
        self.milestoneDescription = milestoneDescription
        self.creator = creator
        self.openIssues = openIssues
        self.closedIssues = closedIssues
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.closedAt = closedAt
        self.dueOn = dueOn
    }

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
