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
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases", expectedHTTPMethod: "GET", jsonFile: "Fixtures/releases", statusCode: 200)
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
                    XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1361993732.0))
                } else {
                    XCTFail("Failed to unwrap `releases.last`")
                }
            case let .failure(error):
                XCTAssert(false, "Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testPostRelease() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases", expectedHTTPMethod: "POST", jsonFile: "post_release", statusCode: 201)
        let task = Octokit().postRelease(
            session,
            owner: "octocat",
            repository: "Hello-World",
            tagName: "v1.0.0",
            targetCommitish: "master",
            name: "v1.0.0 Release",
            body: "The changelog of this release",
            prerelease: false,
            draft: false
        ) { response in
            switch response {
            case let .success(release):
                XCTAssertEqual(release.tagName, "v1.0.0")
                XCTAssertEqual(release.commitish, "master")
                XCTAssertEqual(release.name, "v1.0.0 Release")
                XCTAssertEqual(release.body, "The changelog of this release")
                XCTAssertFalse(release.prerelease)
                XCTAssertFalse(release.draft)
            case let .failure(error):
                XCTAssert(false, "Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
