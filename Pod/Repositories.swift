import Foundation

// MARK: model

@objc public class Repository: AnyObject {
    public let id: Int
    public let owner: User
    public var name: String?
    public var fullName: String?
    public var isPrivate: Bool
    public var description: String?
    public var isFork: Bool?
    public var gitURL: String?
    public var sshURL: String?
    public var cloneURL: String?

    public init(_ json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
            name = json["name"] as? String
            fullName = json["full_name"] as? String
            isPrivate = json["private"] as? Bool ?? false
            description = json["description"] as? String
            isFork = json["fork"] as? Bool
            gitURL = json["git_url"] as? String
            sshURL = json["ssh_url"] as? String
            cloneURL = json["clone_url"] as? String
        } else {
            id = -1
            isPrivate = false
        }
    }
}

// MARK: request

public extension Octokit {
    public func repositories(page: String = "1", perPage: String = "100", completion: (response: Response<[Repository]>) -> Void) {
        loadJSON(RepositoryRouter.ReadRepositories(self, page, perPage), expectedResultType: [[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let repos = json.map { Repository($0) }
                completion(response: Response.Success(Box(repos)))
            }
        }
    }

    public func repository(owner: String, name: String, completion: (response: Response<Repository>) -> Void) {
        loadJSON(RepositoryRouter.ReadRepository(self, owner, name), expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let repo = Repository(json)
                    completion(response: Response.Success(Box(repo)))
                }
            }
        }
    }
}

// MARK: Router

public enum RepositoryRouter: Router {
    case ReadRepositories(Octokit, String, String)
    case ReadRepository(Octokit, String, String)

    public var method: HTTPMethod {
        return .GET
    }

    public var encoding: HTTPEncoding {
        return .URL
    }

    public var params: [String: String] {
        switch self {
        case .ReadRepositories(_, let page, let perPage):
            return ["per_page": perPage, "page": page]
        case .ReadRepository:
            return [:]
        }
    }

    public var path: String {
        switch self {
        case .ReadRepositories:
            return "/user/repos"
        case .ReadRepository(_, let owner, let name):
            return "/repos/\(owner)/\(name)"
        }
    }

    public var URLRequest: NSURLRequest? {
        switch self {
        case .ReadRepositories(let kit, _, _):
            return kit.request(self)
        case .ReadRepository(let kit, _, _):
            return kit.request(self)
        }
    }
}