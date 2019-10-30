import Foundation
import RequestKit

public extension Octokit {

    /**
     Fetches all recent Events on the server
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

    /**
     Fetches all Received Events
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myReceivedEvents(_ session: RequestKitURLSession = URLSession.shared,
                   completion: @escaping (_ response: Response<[Event]>) -> Void) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.myReceivedEvents(configuration, "j0r010l")
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

    /**
     Fetches all Created Events
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func myCreatedEvents(_ session: RequestKitURLSession = URLSession.shared,
                          completion: @escaping (_ response: Response<[Event]>) -> Void) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.myCreatedEvents(configuration, "j0r010l")
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
    // GET /events
    case allEvents(Configuration)

    // GET /users/:username/received_events
    case myReceivedEvents(Configuration, String)

    // GET /users/:username/events
    case myCreatedEvents(Configuration, String)

    var configuration: Configuration {
        switch self {
        case .allEvents(let config):
            return config
        case .myReceivedEvents(let config, _):
            return config
        case .myCreatedEvents(let config, _):
            return config
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
        case .myReceivedEvents(_, let user):
            return "users/\(user)/received_events"
        case .myCreatedEvents(_, let user):
            return "users/\(user)/events"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
