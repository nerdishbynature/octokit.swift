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

// MARK: request

public extension Octokit {
    /// Deletes a reference.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the reference needs to be deleted.
    ///   - ref: The reference to delete.
    ///   - completion: Callback for the outcome of the deletion.
    @discardableResult
    func deleteReference(owner: String,
                         repository: String,
                         ref: String,
                         completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = GITRouter.deleteReference(configuration, owner, repository, ref)
        return router.load(session, completion: completion)
    }
}

// MARK: Router

enum GITRouter: JSONPostRouter {
    case deleteReference(Configuration, String, String, String)

    var configuration: Configuration {
        switch self {
        case let .deleteReference(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .deleteReference:
            return .DELETE
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .deleteReference:
            return .url
        }
    }

    var params: [String: Any] {
        switch self {
        case .deleteReference:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .deleteReference(_, owner, repo, reference):
            return "repos/\(owner)/\(repo)/git/refs/\(reference)"
        }
    }
}
