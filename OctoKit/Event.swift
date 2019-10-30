import Foundation
import RequestKit

public extension Octokit {

    /**
     Fetches the authenticated user
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func allEvents(_ session: RequestKitURLSession = URLSession.shared,
                  completion: @escaping (_ response: Response<[Event]>) -> Void) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.allEvents(self.configuration)
        return router.load(session, expectedResultType: [Event].self) { events, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let events = events {
                    completion(Response.success(events))
                }
            }
        }
    }
}

open class Event: Codable {
    open var id: String
    open var type: String
    open var `public`: Bool
    // open var payload: Any // TODO: what is this thing

    open var created_at: String // TODO: Update to decode Date
    open var org: Org?
    open var actor: Actor
    open var repo: Repo

    open class Org: Codable {
        open var id: Int
        open var login: String
        open var gravatar_id: String
        open var url: String // TODO should be URL
        open var avatar_url: String // TODO should be URL
    }

    open class Actor: Codable {
        open var id: Int
        open var login: String
        open var gravatar_id: String
        open var avatar_url: String // TODO should be URL
        open var url: String // TODO should be URL
    }

    open class Repo: Codable {
        open var id: Int
        open var name: String // "octocat/Hello-World",
        open var url: String // TODO should be URL
    }
}

enum EventRouter: Router {
    case allEvents(Configuration)

    var configuration: Configuration {
        switch self {
        case .allEvents(let config): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var path: String {
        switch self {
        case .allEvents:
            return "events"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
