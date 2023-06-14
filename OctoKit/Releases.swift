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
    public let tarballURL: URL?
    public let zipballURL: URL?
    public let nodeId: String
    public let tagName: String
    public let commitish: String
    public let name: String
    public let body: String
    public let draft: Bool
    public let prerelease: Bool
    public let createdAt: Date
    public let publishedAt: Date?
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
    /// Fetches the list of releases.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    ///   - perPage: Results per page (max 100). Default: `30`.
    ///   - completion: Callback for the outcome of the fetch.
    @discardableResult
    func listReleases(owner: String,
                      repository: String,
                      perPage: Int = 30,
                      completion: @escaping (_ response: Result<[Release], Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReleaseRouter.listReleases(configuration, owner, repository, perPage)
        return router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Release].self) { releases, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let releases = releases {
                    completion(.success(releases))
                }
            }
        }
    }

    /// Fetches a published release with the specified tag.
    /// - Parameters:
    ///   - tag: The specified tag
    ///   - completion: Callback for the outcome of the fetch.
    @discardableResult
    func release(owner: String,
                 repository: String,
                 tag: String,
                 completion: @escaping (_ response: Result<Release, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReleaseRouter.getReleaseByTag(configuration, owner, repository, tag)
        return router.load(session,
                           dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter),
                           expectedResultType: Release.self) { release, error in
            if let error = error {
                completion(.failure(error))
            } else if let release = release {
                completion(.success(release))
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Fetches the list of releases.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    ///   - perPage: Results per page (max 100). Default: `30`.2
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func listReleases(owner: String, repository: String, perPage: Int = 30) async throws -> [Release] {
        let router = ReleaseRouter.listReleases(configuration, owner, repository, perPage)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [Release].self)
    }

    /// Fetches the latest release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func getLatestRelease(owner: String, repository: String) async throws -> Release {
        let router = ReleaseRouter.getLatestRelease(configuration, owner, repository)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Release.self)
    }
    #endif

    /// Creates a new release.
    /// - Parameters:
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
    func postRelease(owner: String,
                     repository: String,
                     tagName: String,
                     targetCommitish: String? = nil,
                     name: String? = nil,
                     body: String? = nil,
                     prerelease: Bool = false,
                     draft: Bool = false,
                     generateNotes: Bool = false,
                     completion: @escaping (_ response: Result<Release, Error>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReleaseRouter.postRelease(configuration, owner, repository, tagName, targetCommitish, name, body, prerelease, draft, generateNotes)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)

        return router.post(session, decoder: decoder, expectedResultType: Release.self) { issue, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let issue = issue {
                    completion(.success(issue))
                }
            }
        }
    }

    /// Deletes a release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the release needs to be deleted.
    ///   - releaseId: The ID of the release to delete.
    ///   - completion: Callback for the outcome of the deletion.
    @discardableResult
    func deleteRelease(owner: String,
                       repository: String,
                       releaseId: Int,
                       completion: @escaping (_ response: Error?) -> Void) -> URLSessionDataTaskProtocol? {
        let router = ReleaseRouter.deleteRelease(configuration, owner, repository, releaseId)
        return router.load(session, completion: completion)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Creates a new release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the release needs to be created.
    ///   - tagName: The name of the tag.
    ///   - targetCommitish: Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Unused if the Git tag already exists. Default: the repository's default branch (usually master).
    ///   - name: The name of the release.
    ///   - body: Text describing the contents of the tag.
    ///   - prerelease: `true` to create a draft (unpublished) release, `false` to create a published one. Default: `false`.
    ///   - draft: `true` to identify the release as a prerelease. `false` to identify the release as a full release. Default: `false`.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func postRelease(owner: String,
                     repository: String,
                     tagName: String,
                     targetCommitish: String? = nil,
                     name: String? = nil,
                     body: String? = nil,
                     prerelease: Bool = false,
                     draft: Bool = false,
                     generateNotes: Bool = false) async throws -> Release {
        let router = ReleaseRouter.postRelease(configuration, owner, repository, tagName, targetCommitish, name, body, prerelease, draft, generateNotes)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try await router.post(session, decoder: decoder, expectedResultType: Release.self)
    }
    #endif
}

// MARK: Router

enum ReleaseRouter: JSONPostRouter {
    case listReleases(Configuration, String, String, Int)
    case getLatestRelease(Configuration, String, String)
    case getReleaseByTag(Configuration, String, String, String)
    case postRelease(Configuration, String, String, String, String?, String?, String?, Bool, Bool, Bool)
    case deleteRelease(Configuration, String, String, Int)

    var configuration: Configuration {
        switch self {
        case let .listReleases(config, _, _, _): return config
        case let .getLatestRelease(config, _, _): return config
        case let .getReleaseByTag(config, _, _, _): return config
        case let .postRelease(config, _, _, _, _, _, _, _, _, _): return config
        case let .deleteRelease(config, _, _, _): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listReleases, .getLatestRelease, .getReleaseByTag:
            return .GET
        case .postRelease:
            return .POST
        case .deleteRelease:
            return .DELETE
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .listReleases, .getLatestRelease, .getReleaseByTag:
            return .url
        case .postRelease:
            return .json
        case .deleteRelease:
            return .url
        }
    }

    var params: [String: Any] {
        switch self {
        case let .listReleases(_, _, _, perPage):
            return ["per_page": "\(perPage)"]
        case .getLatestRelease:
            return [:]
        case .getReleaseByTag:
            return [:]
        case let .postRelease(_, _, _, tagName, targetCommitish, name, body, prerelease, draft, generateNotes):
            var params: [String: Any] = [
                "tag_name": tagName,
                "prerelease": prerelease,
                "draft": draft,
                "generate_release_notes": generateNotes
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
        case .deleteRelease:
            return [:]
        }
    }

    var path: String {
        switch self {
        case let .listReleases(_, owner, repo, _):
            return "repos/\(owner)/\(repo)/releases"
        case let .getLatestRelease(_, owner, repo):
            return "/repos/\(owner)/\(repo)/releases/latest"
        case let .getReleaseByTag(_, owner, repo, tag):
            return "repos/\(owner)/\(repo)/releases/tags/\(tag)"
        case let .postRelease(_, owner, repo, _, _, _, _, _, _, _):
            return "repos/\(owner)/\(repo)/releases"
        case let .deleteRelease(_, owner, repo, releaseId):
            return "repos/\(owner)/\(repo)/releases/\(releaseId)"
        }
    }
}
