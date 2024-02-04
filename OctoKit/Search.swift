//
//  Search.swift
//
//
//  Created by Chidi Williams on 04/02/2024.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

open class SearchResponse<T: Codable>: Codable {
    open var totalCount: Int
    open var incompleteResults: Bool
    open var items: [T]
    
    init(totalCount: Int, incompleteResults: Bool, items: [T]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

open class CodeSearchResultItem: Codable {
    open var name: String
    open var path: String
    open var sha: String
    open var url: URL
    open var gitUrl: URL
    open var htmlUrl: URL
    open var repository: Repository
    open var score: Double
    open var fileSize: Int?
    open var language: String?
    open var lastModifiedAt: Date?
    open var lineNumbers: [String]?
    
    init(name: String,
         path: String,
         sha: String,
         url: URL,
         gitUrl: URL,
         htmlUrl: URL,
         repository: Repository,
         score: Double,
         fileSize: Int? = nil,
         language: String? = nil,
         lastModifiedAt: Date? = nil,
         lineNumbers: [String]? = nil) {
        self.name = name
        self.path = path
        self.sha = sha
        self.url = url
        self.gitUrl = gitUrl
        self.htmlUrl = htmlUrl
        self.repository = repository
        self.score = score
        self.fileSize = fileSize
        self.language = language
        self.lastModifiedAt = lastModifiedAt
        self.lineNumbers = lineNumbers
    }
    
    enum CodingKeys: String, CodingKey {
        case name, path, sha, url
        case gitUrl = "git_url"
        case htmlUrl = "html_url"
        case repository, score
        case fileSize = "file_size"
        case language
        case lastModifiedAt = "last_modified_at"
        case lineNumbers = "line_numbers"
    }
}

// MARK: request

public extension Octokit {
    /**
     Searches for query terms inside of a file
     - parameter query: The query containing one or more search keywords and qualifiers.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     - parameter completion: Callback for the outcome of the fetch.
     */
    @discardableResult
    func searchCode(query: String,
                    page: String = "1",
                    perPage: String = "100",
                    completion: @escaping (_ response: Result<SearchResponse<CodeSearchResultItem>, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = SearchRouter.searchCode(configuration, query, page, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: SearchResponse<CodeSearchResultItem>.self) { response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let response = response {
                    completion(.success(response))
                }
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /**
     Searches for query terms inside of a file
     - parameter query: The query containing one or more search keywords and qualifiers.
     - parameter page: Current page for label pagination. `1` by default.
     - parameter perPage: Number of labels per page. `100` by default.
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func searchCode(query: String, page: String = "1", perPage: String = "100") async throws -> SearchResponse<CodeSearchResultItem> {
        let router = SearchRouter.searchCode(configuration, query, page, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: SearchResponse<CodeSearchResultItem>.self)
    }
    #endif
}

enum SearchRouter: JSONPostRouter {
    case searchCode(Configuration, String, String, String)

    var method: HTTPMethod {
        switch self {
        case .searchCode:
            return .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .searchCode:
            return .url
        }
    }

    var configuration: Configuration {
        switch self {
        case let .searchCode(config, _, _, _): return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .searchCode(_, query, page, perPage):
            return ["q": query, "per_page": perPage, "page": page]
        }
    }

    var path: String {
        switch self {
        case .searchCode:
            return "search/code"
        }
    }
}
