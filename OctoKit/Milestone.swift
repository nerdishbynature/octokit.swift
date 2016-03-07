import Foundation

@objc public class Milestone: NSObject {
    public var url: NSURL?
    public var htmlURL: NSURL?
    public var labelsURL: NSURL?
    public var id: Int
    public var number: Int?
    public var state: Openness?
    public var title: String?
    public var milestoneDescription: String?
    public var creator: User?
    public var openIssues: Int?
    public var closedIssues: Int?
    public var createdAt: NSDate?
    public var updatedAt: NSDate?
    public var closedAt: NSDate?
    public var dueOn: NSDate?
    
    public init?(_ json: [String: AnyObject]) {
        if let id = json["id"] as? Int {
            if let urlString = json["html_url"] as? String, url = NSURL(string: urlString) {
                htmlURL = url
            }
            if let urlString = json["labels_url"] as? String, url = NSURL(string: urlString) {
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
