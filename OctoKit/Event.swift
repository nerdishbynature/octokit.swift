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
    var id: String
    var type: String
    var `public`: Bool
    // var payload: Any // TODO: what is this thing

    var created_at: String // TODO: Update to decode Date
    var org: Org
    var actor: Actor
    var repo: Repo

    struct Org: Codable {
        var id: Int
        var login: String
        var gravatar_id: String
        var url: String // TODO should be URL
        var avatar_url: String // TODO should be URL
    }

    struct Actor: Codable {
        var id: Int
        var login: String
        var gravatar_id: String
        var avatar_url: String // TODO should be URL
        var url: String // TODO should be URL
    }

    struct Repo: Codable {
        var id: Int
        var name: String // "octocat/Hello-World",
        var url: String // TODO should be URL
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
