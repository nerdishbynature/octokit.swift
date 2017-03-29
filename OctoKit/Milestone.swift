import Foundation

@objc open class Milestone: NSObject {
    open var url: URL?
    open var htmlURL: URL?
    open var labelsURL: URL?
    open var id: Int
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
    
    public init?(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            if let urlString = json["html_url"] as? String, let url = URL(string: urlString) {
                htmlURL = url
            }
            if let urlString = json["labels_url"] as? String, let url = URL(string: urlString) {
                labelsURL = url
            }
            self.id = id
            number = json["number"] as? Int
            state = Openness(rawValue: json["state"] as? String ?? "")
            title = json["title"] as? String
            milestoneDescription = json["description"] as? String
            creator = User(json["creator"] as? [String: AnyObject] ?? [:])
            openIssues = json["open_issues"] as? Int
            closedIssues = json["closed_issues"] as? Int
            createdAt = Time.rfc3339Date(json["created_at"] as? String)
            updatedAt = Time.rfc3339Date(json["updated_at"] as? String)
            closedAt = Time.rfc3339Date(json["closed_at"] as? String)
            dueOn = Time.rfc3339Date(json["due_on"] as? String)
        } else {
            id = -1
        }
    }
}
