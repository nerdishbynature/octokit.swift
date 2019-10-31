import Foundation
import RequestKit

open class Event: Codable {
    open var id: String
    open var type: String
    open var `public`: Bool
    // open var payload: Any // TODO: what is this thing

    open var created_at: String // TODO: Update to decode Date
//    open var actor: User
//    open var repo: Repository
}

public extension Octokit {

    /**
     Fetches all recent Events on the server
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func allEvents(_ session: RequestKitURLSession = URLSession.shared,
                   completion: @escaping (_ response: Response<[Event]>) -> Void
    ) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.allEvents(self.configuration)
        return router.load(session, expectedResultType: [Event].self) { events, error in
             if let error = error {
                completion(.failure(error))
                return
            }

            if let events = events {
                completion(.success(events))
            }
        }
    }

    /**
     Fetches all Received Events
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func receivedEvents(_ session: RequestKitURLSession = URLSession.shared,
                        user: String,
                        completion: @escaping (_ response: Response<[Event]>) -> Void
    ) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.receivedEvents(configuration, user)
        return router.load(session, expectedResultType: [Event].self) { events, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let events = events {
                completion(.success(events))
            }
        }
    }

    /**
     Fetches all Created Events
     - parameter session: RequestKitURLSession, defaults to NSURLSession.sharedSession()
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func createdEvents(_ session: RequestKitURLSession = URLSession.shared,
                       user: String,
                       completion: @escaping (_ response: Response<[Event]>) -> Void
    ) -> URLSessionDataTaskProtocol? {

        let router = EventRouter.createdEvents(configuration, user)
        return router.load(session, expectedResultType: [Event].self) { events, error in
            if let error = error {
                completion(.failure(error))
            }

            if let events = events {
                completion(.success(events))
            }
        }
    }
}

enum EventRouter: Router {
    // GET /events
    case allEvents(Configuration)

    // GET /users/:username/received_events
    case receivedEvents(Configuration, String)

    // GET /users/:username/events
    case createdEvents(Configuration, String)

    var configuration: Configuration {
        switch self {
        case .allEvents(let config):
            return config
        case .receivedEvents(let config, _):
            return config
        case .createdEvents(let config, _):
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
        case .receivedEvents(_, let user):
            return "users/\(user)/received_events"
        case .createdEvents(_, let user):
            return "users/\(user)/events"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
