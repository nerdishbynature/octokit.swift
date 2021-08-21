import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Model

open class NotificationThread: Codable {
    open internal(set) var id: String? = "-1"
    open var unread: Bool?
    open var reason: Reason?
    open var updatedAt: Date?
    open var lastReadAt: Date?
    open private(set) var subject = Subject()
    open private(set) var repository = Repository()

    enum CodingKeys: String, CodingKey {
        case id
        case unread
        case reason
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case subject
        case repository
    }

    public class Subject: Codable {
        open internal(set) var id: Int = -1
        open var title: String?
        open var url: String?
        open var latestCommentUrl: String?
        open var type: String?

        enum CodingKeys: String, CodingKey {
            case title
            case url
            case latestCommentUrl = "latest_comment_url"
            case type
        }
    }

    public enum Reason: String, Codable {
        case assign
        case author
        case comment
        case invitation
        case manual
        case mention
        case reviewRequested = "review_requested"
        case securityAlert = "security_alert"
        case stateChange = "state_change"
        case subscribed
        case teamMention = "team_mention"
    }
}

open class ThreadSubscription: Codable {
    open internal(set) var id: Int? = -1
    open var subscribed: Bool?
    open var ignored: Bool?
    open var reason: String?
    open var url: String?
    open var threadUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case subscribed
        case ignored
        case reason
        case url
        case threadUrl = "thread_url"
    }
}

// MARK: - Request

public extension Octokit {
    /**
     List all notifications for the current user, sorted by most recently updated.
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter all: show notifications marked as read `false` by default.
     - parameter participating: only shows notifications in which the user is directly participating or mentioned. `false` by default.
     - parameter page: Current page for notification pagination. `1` by default.
     - parameter perPage: Number of notifications per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myNotifications(_ session: RequestKitURLSession = URLSession.shared, all: Bool = false, participating: Bool = false, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[NotificationThread]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.readNotifications(configuration, all, participating, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [NotificationThread].self) { notifications, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let notifications = notifications {
                    completion(Response.success(notifications))
                }
            }
        }
    }

    /**
     Marks All Notifications As read
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter lastReadAt: Describes the last point that notifications were checked `last_read_at` by default.
     - parameter read: Whether the notification has been read `false` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func markNotificationsRead(_ session: RequestKitURLSession = URLSession.shared, lastReadAt: String = "last_read_at", read: Bool = false, completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.markNotificationsRead(configuration, lastReadAt, read)
        return router.load(session, completion: completion)
    }

    /**
     Marks All Notifications As read
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter threadId: The ID of the Thread.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func getNotificationThread(_ session: RequestKitURLSession = URLSession.shared, threadId: String, completion: @escaping (_ response: Response<NotificationThread>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.getNotificationThread(configuration, threadId)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: NotificationThread.self) { notification, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let notification = notification {
                    completion(Response.success(notification))
                }
            }
        }
    }

    /**
    Get a thread subscription for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter threadId: The ID of the Thread.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func getThreadSubscription(_ session: RequestKitURLSession = URLSession.shared, threadId: String, completion: @escaping (_ response: Response<ThreadSubscription>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.getThreadSubscription(configuration, threadId)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: ThreadSubscription.self) { thread, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let thread = thread {
                    completion(Response.success(thread))
                }
            }
        }
    }

    /**
     Sets a thread subscription for the authenticated user
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter threadId: The ID of the Thread.
     - parameter ignored: Whether to block all notifications from a thread `false` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func setThreadSubscription(_ session: RequestKitURLSession = URLSession.shared, threadId: String, ignored: Bool = false, completion: @escaping (_ response: Response<ThreadSubscription>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.setThreadSubscription(configuration, threadId, ignored)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: ThreadSubscription.self) { thread, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let thread = thread {
                    completion(Response.success(thread))
                }
            }
        }
    }

    /**
     Delete a thread subscription
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter threadId: The ID of the Thread.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func deleteThreadSubscription(_ session: RequestKitURLSession = URLSession.shared, threadId: String, completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.deleteThreadSubscription(configuration, threadId)
        return router.load(session, completion: completion)
    }

    /**
     List all repository notifications for the current user, sorted by most recently updated.
     - parameter session: RequestKitURLSession, defaults to URLSession.shared
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - parameter all: show notifications marked as read `false` by default.
     - parameter participating: only shows notifications in which the user is directly participating or mentioned. `false` by default.
     - parameter since: Only show notifications updated after the given time.
     - parameter before: Only show notifications updated before the given time.
     - parameter page: Current page for notification pagination. `1` by default.
     - parameter perPage: Number of notifications per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func listRepositoryNotifications(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, all: Bool = false, participating: Bool = false, since: String? = nil, before: String? = nil, page: String = "1", perPage: String = "100", completion: @escaping (_ response: Response<[NotificationThread]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.listRepositoryNotifications(configuration, owner, repository, all, participating, since, before, perPage, page)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [NotificationThread].self) { notifications, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let notifications = notifications {
                    completion(Response.success(notifications))
                }
            }
        }
    }

    /**
     Marks All Repository Notifications As read
     - parameter session: RequestKitURLSession, defaults to URLSession.sharedSession()
     - parameter owner: The name of the owner of the repository.
     - parameter repository: The name of the repository.
     - parameter lastReadAt: Describes the last point that notifications were checked `last_read_at` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func markRepositoryNotificationsRead(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, lastReadAt: String? = nil, completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = NotificationRouter.markRepositoryNotificationsRead(configuration, owner, repository, lastReadAt)
        return router.load(session, completion: completion)
    }
}

// MARK: - Router

enum NotificationRouter: Router {
    case readNotifications(Configuration, Bool, Bool, String, String)
    case markNotificationsRead(Configuration, String, Bool)
    case getNotificationThread(Configuration, String)
    case markNotificationThreadAsRead(Configuration, String)
    case getThreadSubscription(Configuration, String)
    case setThreadSubscription(Configuration, String, Bool)
    case deleteThreadSubscription(Configuration, String)
    case listRepositoryNotifications(Configuration, String, String, Bool, Bool, String?, String?, String, String)
    case markRepositoryNotificationsRead(Configuration, String, String, String?)

    var configuration: Configuration {
        switch self {
        case .readNotifications(let config, _, _, _, _): return config
        case .markNotificationsRead(let config, _, _): return config
        case .getNotificationThread(let config, _), .markNotificationThreadAsRead(let config, _): return config
        case .getThreadSubscription(let config, _): return config
        case .setThreadSubscription(let config, _, _): return config
        case .deleteThreadSubscription(let config, _): return config
        case .listRepositoryNotifications(let config, _, _, _, _, _, _, _, _): return config
        case .markRepositoryNotificationsRead(let config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .readNotifications,
             .getNotificationThread,
             .getThreadSubscription,
             .listRepositoryNotifications:
            return .GET
        case .markNotificationsRead,
             .setThreadSubscription,
             .markRepositoryNotificationsRead:
            return .PUT
        case .markNotificationThreadAsRead:
            return .POST
        case .deleteThreadSubscription:
            return .DELETE
        }
    }

    var encoding: HTTPEncoding {
        .url
    }

    var path: String {
        switch self {
        case .readNotifications,
             .markNotificationsRead:
            return "notifications"
        case .getNotificationThread(_, let threadID):
            return "notifications/threads/\(threadID)"
        case .markNotificationThreadAsRead:
            return "notifications/threads/"
        case .getThreadSubscription(_, let threadId),
             .setThreadSubscription(_, let threadId, _),
             .deleteThreadSubscription(_, let threadId):
            return "notifications/threads/\(threadId)/subscription"
        case .listRepositoryNotifications(_, let owner, let repo, _, _, _, _, _, _),
             .markRepositoryNotificationsRead(_, let owner, let repo, _):
            return "repos/\(owner)/\(repo)/notifications"
        }
    }

    var params: [String: Any] {
        switch self {
        case .readNotifications(_, let all, let participating, let page, let perPage):
            return ["all": "\(all)", "participating": "\(participating)", "page": page, "per_page": perPage]
        case .markNotificationsRead(_, let lastReadAt, let read):
            return ["last_read_at": lastReadAt, "read": "\(read)"]
        case .getNotificationThread:
            return [:]
        case .markNotificationThreadAsRead(_, let threadID):
            return ["thread_id": threadID]
        case .getThreadSubscription:
            return [:]
        case .setThreadSubscription:
            return [:]
        case .deleteThreadSubscription:
            return [:]
        case .listRepositoryNotifications(_, _, _, let all, let participating, let since, let before, let perPage, let page):
            var params: [String: String] = [
                "all": all.description,
                "participating": participating.description,
                "perPage": perPage,
                "page": page
            ]
            if let since = since {
                params["since"] = since
            }
            if let before = before {
                params["before"] = before
            }
            return params
        case .markRepositoryNotificationsRead(_, _, _, let lastReadAt):
            var params: [String: String] = [:]
            if let lastReadAt = lastReadAt {
                params["last_read_at"] = lastReadAt
            }
            return params
        }
    }
}
