//
//  Git.swift
//  OctoKit
//
//  Created by Antoine van der Lee on 25/01/2022.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Models

public class GitTree: Codable {
    public var sha: String
    public var url: String
    public var tree: [GitTreeEntry]
    public var isTruncated: Bool

    enum CodingKeys: String, CodingKey {
        case sha, url, tree
        case isTruncated = "truncated"
    }
}

public class GitTreeEntry: Codable {
    public var path: String?
    public var mode: String?
    public var type: String?
    public var size: Int?
    public var sha: String?
    public var url: String?
}

public class GitRef: Codable {
    public var ref: String
    public var nodeId: String
    public var url: String
    public var object: GitObject

    enum CodingKeys: String, CodingKey {
        case ref, url, object
        case nodeId = "node_id"
    }
}

public class GitObject: Codable {
    public var type: String
    public var sha: String
    public var url: String
}

// MARK: - Requests

public extension Octokit {
    /// Fetches a git tree.
    @discardableResult
    func tree(owner: String,
              repository: String,
              treeSHA: String,
              recursive: Bool = false,
              completion: @escaping (_ response: Result<GitTree, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GITRouter.tree(configuration, owner, repository, treeSHA, recursive)
        return router.load(session, decoder: configuration.decoder, expectedResultType: GitTree.self) { tree, error in
            if let error = error {
                completion(.failure(error))
            } else if let tree = tree {
                completion(.success(tree))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func tree(owner: String,
              repository: String,
              treeSHA: String,
              recursive: Bool = false) async throws -> GitTree {
        let router = GITRouter.tree(configuration, owner, repository, treeSHA, recursive)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: GitTree.self)
    }
    #endif

    /// Lists git refs for a repository, optionally filtered by a ref prefix.
    @discardableResult
    func listRefs(owner: String,
                  repository: String,
                  ref: String? = nil,
                  completion: @escaping (_ response: Result<[GitRef], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GITRouter.listRefs(configuration, owner, repository, ref)
        return router.load(session, decoder: configuration.decoder, expectedResultType: [GitRef].self) { refs, error in
            if let error = error {
                completion(.failure(error))
            } else if let refs = refs {
                completion(.success(refs))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listRefs(owner: String,
                  repository: String,
                  ref: String? = nil) async throws -> [GitRef] {
        let router = GITRouter.listRefs(configuration, owner, repository, ref)
        return try await router.load(session, decoder: configuration.decoder, expectedResultType: [GitRef].self)
    }
    #endif

    /// Deletes a reference.
    @discardableResult
    func deleteReference(owner: String,
                         repository: String,
                         ref: String,
                         completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GITRouter.deleteReference(configuration, owner, repository, ref)
        return router.load(session, completion: completion)
    }
}

// MARK: - Router

enum GITRouter: JSONPostRouter {
    case tree(Configuration, String, String, String, Bool)
    case listRefs(Configuration, String, String, String?)
    case deleteReference(Configuration, String, String, String)

    var configuration: Configuration {
        switch self {
        case let .tree(config, _, _, _, _): return config
        case let .listRefs(config, _, _, _): return config
        case let .deleteReference(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .tree, .listRefs:
            return .GET
        case .deleteReference:
            return .DELETE
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .tree, .listRefs, .deleteReference:
            return .url
        }
    }

    var params: [String: Any] {
        switch self {
        case let .tree(_, _, _, _, recursive):
            return recursive ? ["recursive": "1"] : [:]
        case .listRefs, .deleteReference:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .tree(_, owner, repo, sha, _):
            return "repos/\(owner)/\(repo)/git/trees/\(sha)"
        case let .listRefs(_, owner, repo, ref):
            if let ref = ref {
                return "repos/\(owner)/\(repo)/git/refs/\(ref)"
            }
            return "repos/\(owner)/\(repo)/git/refs"
        case let .deleteReference(_, owner, repo, reference):
            return "repos/\(owner)/\(repo)/git/refs/\(reference)"
        }
    }
}
