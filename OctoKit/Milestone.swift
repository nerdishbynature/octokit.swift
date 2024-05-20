import Foundation
import RequestKit

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

// MARK: Request

public extension Octokit {
    /**
     Create a milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter title: The title of the new milestone.
     - parameter state: Filter pulls by their state.
     - parameter description: The description of the new milestone.
     - parameter date: The milestone due date
     - parameter completion: Callback for the outcome of the create
     */
    @discardableResult
    func createMilestone(owner: String,
                         repo: String,
                         title: String,
                         state: Openness? = nil,
                         description: String? = nil,
                         dueDate: Date? = nil,
                         completion: @escaping (_ response: Result<Milestone, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = MilestoneRouter.createMilestone(configuration, owner, repo, title, state, description, dueDate)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Milestone.self) { milestone, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let milestone {
                    completion(.success(milestone))
                }
            }
        }
    }
    
#if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    /**
     Create a milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter title: The title of the new milestone.
     - parameter state: Filter pulls by their state.
     - parameter description: The description of the new milestone.
     - parameter date: The milestone due date
     */
    @discardableResult
    func createMilestone(owner: String,
                         repo: String,
                         title: String,
                         state: Openness? = nil,
                         description: String? = nil,
                         dueDate: Date? = nil) async throws -> Milestone {
        let router = MilestoneRouter.createMilestone(configuration, owner, repo, title, state, description, dueDate)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(
            session,
            decoder: decoder,
            expectedResultType: Milestone.self)
    }
#endif
    
    /**
     Get a single milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func milestone(owner: String,
                   repo: String,
                   number: Int,
                   completion: @escaping (_ response: Result<Milestone, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = MilestoneRouter.readMilestone(configuration, owner, repo, number)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Milestone.self) { milestone, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let milestone {
                    completion(.success(milestone))
                }
            }
        }
    }
    
#if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Get a single milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func milestone(owner: String,
                   repo: String,
                   number: Int) async throws -> Milestone {
        let router = MilestoneRouter.readMilestone(configuration, owner, repo, number)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Milestone.self)
    }
#endif
    
    /**
     Get a list of milestones
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter page: The page to request.
     - parameter perPage: The number of pulls to return on each page, max is 100.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func milestones(owner: String,
                    repo: String,
                    state: Openness = .open,
                    sort: SortType = .created,
                    direction: SortDirection = .desc,
                    page: Int? = nil,
                    perPage: Int? = nil,
                    completion: @escaping (_ response: Result<[Milestone], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = MilestoneRouter.readMilestones(configuration, owner, repo, state, sort, direction, perPage, page)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.load(session, decoder: decoder, expectedResultType: [Milestone].self) { milestones, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let milestones {
                    completion(.success(milestones))
                }
            }
        }
    }
    
#if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Get a list of milestones
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter state: Filter pulls by their state.
     - parameter direction: The direction of the sort.
     - parameter page: The page to request.
     - parameter perPage: The number of pulls to return on each page, max is 100.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func milestones(owner: String,
                    repo: String,
                    state: Openness = .open,
                    sort: SortType = .created,
                    direction: SortDirection = .desc,
                    page: Int? = nil,
                    perPage: Int? = nil) async throws -> [Milestone] {
        let router = MilestoneRouter.readMilestones(configuration, owner, repo, state, sort, direction, perPage, page)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.load(session, decoder: decoder, expectedResultType: [Milestone].self)
    }
#endif
    
    /**
     Update a milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     - parameter title: The title of the new milestone.
     - parameter state: Filter pulls by their state.
     - parameter description: The description of the new milestone.
     - parameter date: The milestone due date
     - parameter completion: Callback for the outcome of the update
     */
    @discardableResult
    func updateMilestone(owner: String,
                         repo: String,
                         number: Int,
                         title: String? = nil,
                         state: Openness? = nil,
                         description: String? = nil,
                         dueDate: Date? = nil,
                         completion: @escaping (_ response: Result<Milestone, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = MilestoneRouter.updateMilestone(configuration, owner, repo, number, title, state, description, dueDate)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return router.post(session, decoder: decoder, expectedResultType: Milestone.self) { milestone, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let milestone {
                    completion(.success(milestone))
                }
            }
        }
    }
    
#if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Update a milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     - parameter title: The title of the new milestone.
     - parameter state: Filter pulls by their state.
     - parameter description: The description of the new milestone.
     - parameter date: The milestone due date
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func updateMilestone(owner: String,
                         repo: String,
                         number: Int,
                         title: String? = nil,
                         state: Openness? = nil,
                         description: String? = nil,
                         dueDate: Date? = nil) async throws -> Milestone {
        let router = MilestoneRouter.updateMilestone(configuration, owner, repo, number, title, state, description, dueDate)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Milestone.self)
    }
#endif
    
    /**
     Delete a single milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     - parameter completion: Callback for the outcome of the deletion.
     */
    @discardableResult
    func deleteMilestone(owner: String,
                         repo: String,
                         number: Int,
                         completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = MilestoneRouter.deleteMilestone(configuration, owner, repo, number)
        return router.load(session, completion: completion)
    }
    
#if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Delete a single milestone
     - parameter owner: The user or organization that owns the repositories.
     - parameter repo: The name of the repository.
     - parameter number: The number that identifies the milestone.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func deleteMilestone(owner: String,
                         repo: String,
                         number: Int) async throws {
        let router = MilestoneRouter.deleteMilestone(configuration, owner, repo, number)
        return try await router.load(session)
    }
#endif
}

// MARK: Router
enum MilestoneRouter: Router, JSONPostRouter {
    typealias Owner = String
    typealias Repo = String
    typealias Page = Int
    typealias PerPage = Int
    typealias Title = String
    typealias Description = String
    typealias MilestoneNumber = Int
    
    case readMilestones(Configuration, Owner, Repo, Openness, SortType, SortDirection, PerPage?, Page?)
    case readMilestone(Configuration, Owner, Repo, MilestoneNumber)
    case createMilestone(Configuration, Owner, Repo, Title, Openness?, Description?, Date?)
    case updateMilestone(Configuration, Owner, Repo, MilestoneNumber, Title?, Openness?, Description?, Date?)
    case deleteMilestone(Configuration, Owner, Repo, MilestoneNumber)
    
    var configuration: Configuration {
        switch self {
        case let .readMilestones(config, _, _, _, _, _, _, _): return config
        case let .readMilestone(config, _, _, _): return config
        case let .createMilestone(config, _, _, _, _, _, _): return config
        case let .updateMilestone(config, _, _, _, _, _, _, _): return config
        case let .deleteMilestone(config, _, _, _): return config
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .readMilestones, .readMilestone:
            return .GET
        case .createMilestone:
            return .POST
        case .updateMilestone:
            return .PATCH
        case .deleteMilestone:
            return .DELETE
        }
    }
    
    var encoding: HTTPEncoding {
        switch self {
        case .readMilestones, .readMilestone, .deleteMilestone:
            return .url
        case .createMilestone, .updateMilestone:
            return .json
        }
    }
    
    var params: [String: Any] {
        switch self {
        case let .readMilestones(_, _, _, state, sort, direction, page, perPage):
            var parameters: [String: Any] = [
                "state": state.rawValue,
                "sort": sort.rawValue,
                "direction": direction.rawValue
            ]
            
            if let page {
                parameters["page"] = page
            }
            
            if let perPage {
                parameters["per_page"] = perPage
            }
            
            return parameters
            
        case let .createMilestone(_, _, _, title, state, description, date):
            var parameters: [String: Any] = [
                "title": title
            ]
            
            if let state {
                if state == .all {
                    parameters["state"] = Openness.open.rawValue
                } else {
                    parameters["state"] = state.rawValue
                }
            }
            
            if let description {
                parameters["description"] = description
            }
            
            if let date {
                parameters["due_on"] = Time.rfc3339DateFormatter.string(from: date)
            }
            
            return parameters
            
        case .readMilestone: return [:]
            
        case let .updateMilestone(_, _, _, _, title, state, description, date):
            var parameters: [String: Any] = [:]
            
            if let title {
                parameters["title"] = title
            }
            if let state {
                if state == .all {
                    parameters["state"] = Openness.open.rawValue
                } else {
                    parameters["state"] = state.rawValue
                }
            }
            
            if let description {
                parameters["description"] = description
            }
            
            if let date {
                parameters["due_on"] = Time.rfc3339DateFormatter.string(from: date)
            }
            
            return parameters
            
        case .deleteMilestone: return [:]
        }
    }
    
    var path: String {
        switch self {
        case let .readMilestones(_, owner, repo, _, _, _, _, _):
            return "repos/\(owner)/\(repo)/milestones"
        case let .readMilestone(_, owner, repo, number):
            return "repos/\(owner)/\(repo)/milestones/\(number)"
        case let .createMilestone(_, owner, repo, _, _, _, _):
            return "repos/\(owner)/\(repo)/milestones"
        case let .updateMilestone(_, owner, repo, number, _, _, _, _):
            return "repos/\(owner)/\(repo)/milestones/\(number)"
        case let .deleteMilestone(_, owner, repo, number):
            return "repos/\(owner)/\(repo)/milestones/\(number)"
        }
    }
}
