import Foundation

@objc public enum MilestoneState: Int {
    case Open
    case Closed
}

@objc public class Milestone: NSObject {
    public var url: NSURL?
    public var htmlURL: NSURL?
    public var labelsURL: NSURL?
    public var id: Int
    public var number: Int?
    public var state: MilestoneState?
    public var title: String?
    public var milestoneDescription: String?
    public var creator: User?
    public var numberOfOpenIssues: Int?
    public var numberOfClosedIssues: Int?
    public var creationDate: NSDate?
    public var updateDate: NSDate?
    public var closureDate: NSDate?
    public var dueDate: NSDate?
    
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
            switch json["state"] as? String ?? "" {
            case "open":
                state = .Open
            case "closed":
                state = .Closed
            default:
                break
            }
            title = json["title"] as? String
            milestoneDescription = json["description"] as? String
            creator = User(json["creator"] as? [String: AnyObject] ?? [:])
            numberOfOpenIssues = json["open_issues"] as? Int
            numberOfClosedIssues = json["closed_issues"] as? Int
            creationDate = Time.rfc3339Date(json["created_at"] as? String)
            updateDate = Time.rfc3339Date(json["updated_at"] as? String)
            closureDate = Time.rfc3339Date(json["closed_at"] as? String)
            dueDate = Time.rfc3339Date(json["due_on"] as? String)
        } else {
            self.id = -1
        }
    }
}
