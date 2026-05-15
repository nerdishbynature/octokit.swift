import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Models

open class IssueEvent: Codable {
    open var id: Int
    open var url: URL?
    open var actor: User?
    open var event: String?
    open var commitId: String?
    open var commitUrl: URL?
    open var createdAt: Date?
    open var issue: Issue?

    enum CodingKeys: String, CodingKey {
        case id, url, actor, event, issue
        case commitId = "commit_id"
        case commitUrl = "commit_url"
        case createdAt = "created_at"
    }
}

// MARK: - Requests

public extension Octokit {
    @discardableResult
    func issueEvents(owner: String,
                     repository: String,
                     issueNumber: Int,
                     page: String = "1",
                     perPage: String = "100",
                     completion: @escaping (_ response: Result<[IssueEvent], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueEventRouter.readIssueEvents(configuration, owner, repository, issueNumber, page, perPage)
        return router.load(session, decoder: configuration.decoder, expectedResultType: [IssueEvent].self) { events, error in
            if let error = error {
                completion(.failure(error))
            } else if let events = events {
                completion(.success(events))
            }
        }
    }

    @discardableResult
    func repositoryIssueEvents(owner: String,
                               repository: String,
                               page: String = "1",
                               perPage: String = "100",
                               completion: @escaping (_ response: Result<[IssueEvent], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueEventRouter.readRepositoryIssueEvents(configuration, owner, repository, page, perPage)
        return router.load(session, decoder: configuration.decoder, expectedResultType: [IssueEvent].self) { events, error in
            if let error = error {
                completion(.failure(error))
            } else if let events = events {
                completion(.success(events))
            }
        }
    }

    @discardableResult
    func issueEvent(owner: String,
                    repository: String,
                    id: Int,
                    completion: @escaping (_ response: Result<IssueEvent, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = IssueEventRouter.readIssueEvent(configuration, owner, repository, id)
        return router.load(session, decoder: configuration.decoder, expectedResultType: IssueEvent.self) { event, error in
            if let error = error {
                completion(.failure(error))
            } else if let event = event {
                completion(.success(event))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issueEvents(owner: String,
                     repository: String,
                     issueNumber: Int,
                     page: String = "1",
                     perPage: String = "100") async throws -> [IssueEvent] {
        let router = IssueEventRouter.readIssueEvents(configuration, owner, repository, issueNumber, page, perPage)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [IssueEvent].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func repositoryIssueEvents(owner: String,
                               repository: String,
                               page: String = "1",
                               perPage: String = "100") async throws -> [IssueEvent] {
        let router = IssueEventRouter.readRepositoryIssueEvents(configuration, owner, repository, page, perPage)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [IssueEvent].self)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func issueEvent(owner: String,
                    repository: String,
                    id: Int) async throws -> IssueEvent {
        let router = IssueEventRouter.readIssueEvent(configuration, owner, repository, id)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: IssueEvent.self)
    }
    #endif
}

// MARK: - Router

enum IssueEventRouter: JSONPostRouter {
    case readIssueEvents(Configuration, String, String, Int, String, String)
    case readRepositoryIssueEvents(Configuration, String, String, String, String)
    case readIssueEvent(Configuration, String, String, Int)

    var configuration: Configuration {
        switch self {
        case let .readIssueEvents(config, _, _, _, _, _): return config
        case let .readRepositoryIssueEvents(config, _, _, _, _): return config
        case let .readIssueEvent(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
        case let .readIssueEvents(_, _, _, _, page, perPage):
            return ["page": page, "per_page": perPage]
        case let .readRepositoryIssueEvents(_, _, _, page, perPage):
            return ["page": page, "per_page": perPage]
        case .readIssueEvent:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .readIssueEvents(_, owner, repo, issueNumber, _, _):
            return "repos/\(owner)/\(repo)/issues/\(issueNumber)/events"
        case let .readRepositoryIssueEvents(_, owner, repo, _, _):
            return "repos/\(owner)/\(repo)/issues/events"
        case let .readIssueEvent(_, owner, repo, id):
            return "repos/\(owner)/\(repo)/issues/events/\(id)"
        }
    }
}
