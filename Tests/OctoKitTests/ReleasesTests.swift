//
//  ReleasesTests.swift
//  OctoKitTests
//
//  Created by Antoine van der Lee on 31/01/2020.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import OctoKit
import XCTest

final class ReleasesTests: XCTestCase {
    // MARK: Actual Request tests

    func testListReleases() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases?per_page=30",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "Fixtures/releases",
                                            statusCode: 200)
        let task = Octokit().listReleases(session, owner: "octocat", repository: "Hello-World") {
            switch $0 {
            case let .success(releases):
                XCTAssertEqual(releases.count, 2)
                if let release = releases.first {
                    XCTAssertEqual(release.tagName, "v1.0.0")
                    XCTAssertEqual(release.commitish, "master")
                    XCTAssertEqual(release.name, "v1.0.0 Release")
                    XCTAssertEqual(release.body, "The changelog of this release")
                    XCTAssertFalse(release.prerelease)
                    XCTAssertTrue(release.draft)
                    XCTAssertNil(release.tarballURL)
                    XCTAssertNil(release.zipballURL)
                    XCTAssertNil(release.publishedAt)
                } else {
                    XCTFail("Failed to unwrap `releases.first`")
                }
                if let release = releases.last {
                    XCTAssertEqual(release.tagName, "v1.0.0")
                    XCTAssertEqual(release.commitish, "master")
                    XCTAssertEqual(release.name, "v1.0.0 Release")
                    XCTAssertEqual(release.body, "The changelog of this release")
                    XCTAssertFalse(release.prerelease)
                    XCTAssertFalse(release.draft)
                    XCTAssertEqual(release.tarballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
                    XCTAssertEqual(release.zipballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
                    XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1_361_993_732.0))
                } else {
                    XCTFail("Failed to unwrap `releases.last`")
                }
            case let .failure(error):
                XCTFail("Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testListReleasesCustomLimit() {
        let perPage = (0 ... 50).randomElement()!
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases?per_page=\(perPage)",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "Fixtures/releases",
                                            statusCode: 200)
        let task = Octokit().listReleases(session, owner: "octocat", repository: "Hello-World", perPage: perPage) {
            switch $0 {
            case .success:
                break
            case let .failure(error):
                XCTAssert(false, "Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListReleasesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases?per_page=30",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "Fixtures/releases",
                                            statusCode: 200)
        let releases = try await Octokit().listReleases(session, owner: "octocat", repository: "Hello-World")
        XCTAssertEqual(releases.count, 2)
        if let release = releases.first {
            XCTAssertEqual(release.tagName, "v1.0.0")
            XCTAssertEqual(release.commitish, "master")
            XCTAssertEqual(release.name, "v1.0.0 Release")
            XCTAssertEqual(release.body, "The changelog of this release")
            XCTAssertFalse(release.prerelease)
            XCTAssertTrue(release.draft)
            XCTAssertNil(release.tarballURL)
            XCTAssertNil(release.zipballURL)
            XCTAssertNil(release.publishedAt)
        } else {
            XCTFail("Failed to unwrap `releases.first`")
        }
        if let release = releases.last {
            XCTAssertEqual(release.tagName, "v1.0.0")
            XCTAssertEqual(release.commitish, "master")
            XCTAssertEqual(release.name, "v1.0.0 Release")
            XCTAssertEqual(release.body, "The changelog of this release")
            XCTAssertFalse(release.prerelease)
            XCTAssertFalse(release.draft)
            XCTAssertEqual(release.tarballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
            XCTAssertEqual(release.zipballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
            XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1_361_993_732.0))
        } else {
            XCTFail("Failed to unwrap `releases.last`")
        }
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testPostRelease() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases", expectedHTTPMethod: "POST", jsonFile: "post_release", statusCode: 201)
        let task = Octokit().postRelease(session,
                                         owner: "octocat",
                                         repository: "Hello-World",
                                         tagName: "v1.0.0",
                                         targetCommitish: "master",
                                         name: "v1.0.0 Release",
                                         body: "The changelog of this release",
                                         prerelease: false,
                                         draft: false,
                                         generateNotes: false) { response in
            switch response {
            case let .success(release):
                XCTAssertEqual(release.tagName, "v1.0.0")
                XCTAssertEqual(release.commitish, "master")
                XCTAssertEqual(release.name, "v1.0.0 Release")
                XCTAssertEqual(release.body, "The changelog of this release")
                XCTAssertFalse(release.prerelease)
                XCTAssertFalse(release.draft)
            case let .failure(error):
                XCTFail("Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testReleaseTagName() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases/tags/v1.0.0",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "Fixtures/release",
                                            statusCode: 201)
        let task = Octokit().release(session, owner: "octocat", repository: "Hello-World", tag: "v1.0.0") {
            switch $0 {
            case let .success(release):
                XCTAssertEqual(release.tagName, "v1.0.0")
                XCTAssertEqual(release.commitish, "master")
                XCTAssertEqual(release.name, "v1.0.0 Release")
                XCTAssertEqual(release.body, "The changelog of this release")
                XCTAssertFalse(release.prerelease)
                XCTAssertFalse(release.draft)
                XCTAssertEqual(release.tarballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
                XCTAssertEqual(release.zipballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
                XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1361993732.0))
            case let .failure(error):
                XCTAssert(false, "Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPostReleaseAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases", expectedHTTPMethod: "POST", jsonFile: "post_release", statusCode: 201)
        let release = try await Octokit().postRelease(session,
                                                      owner: "octocat",
                                                      repository: "Hello-World",
                                                      tagName: "v1.0.0",
                                                      targetCommitish: "master",
                                                      name: "v1.0.0 Release",
                                                      body: "The changelog of this release",
                                                      prerelease: false,
                                                      draft: false,
                                                      generateNotes: false)
        XCTAssertEqual(release.tagName, "v1.0.0")
        XCTAssertEqual(release.commitish, "master")
        XCTAssertEqual(release.name, "v1.0.0 Release")
        XCTAssertEqual(release.body, "The changelog of this release")
        XCTAssertFalse(release.prerelease)
        XCTAssertFalse(release.draft)

        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
