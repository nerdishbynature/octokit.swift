//
//  Releases.swift
//  OctoKit
//
//  Created by Antoine van der Lee on 31/01/2020.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: model
public struct Release: Codable {
    public let id: Int
    public let url: URL
    public let htmlURL: URL
    public let assetsURL: URL
    public let tarballURL: URL
    public let zipballURL: URL
    public let nodeId: String
    public let tagName: String
    public let commitish: String
    public let name: String
    public let body: String
    public let draft: Bool
    public let prerelease: Bool
    public let createdAt: Date
    public let publishedAt: Date
    public let author: User

    enum CodingKeys: String, CodingKey {
        case id, url, name, body, draft, prerelease, author

        case htmlURL = "html_url"
        case assetsURL = "assets_url"
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"
        case nodeId = "node_id"
        case tagName = "tag_name"
        case commitish = "target_commitish"
        case createdAt = "created_at"
        case publishedAt = "published_at"
    }
}

// MARK: request

public extension Octokit {

    /// Creates a new release.
    /// - Parameters:
    ///   - session: RequestKitURLSession, defaults to URLSession.shared()
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the release needs to be created.
    ///   - tagName: The name of the tag.
    ///   - targetCommitish: Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Unused if the Git tag already exists. Default: the repository's default branch (usually master).
    ///   - name: The name of the release.
    ///   - body: Text describing the contents of the tag.
    ///   - prerelease: `true` to create a draft (unpublished) release, `false` to create a published one. Default: `false`.
    ///   - draft: `true` to identify the release as a prerelease. `false` to identify the release as a full release. Default: `false`.
    ///   - completion: Callback for the outcome of the created release.
    @discardableResult
    func postRelease(_ session: RequestKitURLSession = URLSession.shared, owner: String, repository: String, tagName: String, targetCommitish: String? = nil, name: String? = nil, body: String? = nil, prerelease: Bool = false, draft: Bool = false, completion: @escaping (_ response: Response<Release>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReleaseRouter.postRelease(configuration, owner, repository, tagName, targetCommitish, name, body, prerelease, draft)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)

        return router.post(session, decoder: decoder, expectedResultType: Release.self) { issue, error in
            if let error = error {
                completion(Response.failure(error))
            } else {
                if let issue = issue {
                    completion(Response.success(issue))
                }
            }
        }
    }
}

// MARK: Router

enum ReleaseRouter: JSONPostRouter {
    case postRelease(Configuration, String, String, String, String?, String?, String?, Bool, Bool)

    var configuration: Configuration {
        switch self {
        case .postRelease(let config, _, _, _, _, _, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .POST
    }

    var encoding: HTTPEncoding {
        return .json
    }

    var params: [String: Any] {
        switch self {
        case .postRelease(_, _, _, let tagName, let targetCommitish, let name, let body, let prerelease, let draft):
            var params: [String: Any] = [
                "tag_name": tagName,
                "prerelease": prerelease,
                "draft": draft
            ]
            if let targetCommitish = targetCommitish {
                params["target_commitish"] = targetCommitish
            }
            if let name = name {
                params["name"] = name
            }
            if let body = body {
                params["body"] = body
            }
            return params
        }
    }

    var path: String {
        switch self {
        case .postRelease(_, let owner, let repo, _, _, _, _, _, _):
            return "repos/\(owner)/\(repo)/releases"
        }
    }
}
