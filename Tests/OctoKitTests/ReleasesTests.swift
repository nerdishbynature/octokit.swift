//
//  ReleasesTests.swift
//  OctoKitTests
//
//  Created by Antoine van der Lee on 31/01/2020.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import XCTest
import OctoKit

final class ReleasesTests: XCTestCase {
    static var allTests = [
        ("testListReleases", testListReleases),
        ("testPostRelease", testPostRelease),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    // MARK: Actual Request tests

    func testListReleases() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/releases", expectedHTTPMethod: "GET", jsonFile: "Fixtures/releases", statusCode: 200)
        let task = Octokit().listReleases(session, owner: "octocat", repository: "Hello-World") {
            switch $0 {
            case let .success(releases):
                XCTAssertEqual(releases.count, 2)
                do {
                    let release = try XCTUnwrap(releases.first)
                    XCTAssertEqual(release.tagName, "v1.0.0")
                    XCTAssertEqual(release.commitish, "master")
                    XCTAssertEqual(release.name, "v1.0.0 Release")
                    XCTAssertEqual(release.body, "The changelog of this release")
                    XCTAssertFalse(release.prerelease)
                    XCTAssertTrue(release.draft)
                    XCTAssertNil(release.tarballURL)
                    XCTAssertNil(release.zipballURL)
                    XCTAssertNil(release.publishedAt)
                } catch {
                    XCTFail("Unwrap failed with error \(error)")
                }
                do {
                    let release = try XCTUnwrap(releases.last)
                    XCTAssertEqual(release.tagName, "v1.0.0")
                    XCTAssertEqual(release.commitish, "master")
                    XCTAssertEqual(release.name, "v1.0.0 Release")
                    XCTAssertEqual(release.body, "The changelog of this release")
                    XCTAssertFalse(release.prerelease)
                    XCTAssertFalse(release.draft)
                    XCTAssertNotNil(release.tarballURL)
                    XCTAssertNotNil(release.zipballURL)
                    XCTAssertNotNil(release.publishedAt)
                } catch {
                    XCTFail("Unwrap failed with error \(error)")
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
        let task = Octokit().postRelease(session, owner: "octocat", repository: "Hello-World", tagName: "v1.0.0", targetCommitish: "master", name: "v1.0.0 Release", body: "The changelog of this release", prerelease: false, draft: false) { response in
            switch response {
            case .success(let release):
                XCTAssertEqual(release.tagName, "v1.0.0")
                XCTAssertEqual(release.commitish, "master")
                XCTAssertEqual(release.name, "v1.0.0 Release")
                XCTAssertEqual(release.body, "The changelog of this release")
                XCTAssertFalse(release.prerelease)
                XCTAssertFalse(release.draft)
            case .failure(let error):
                XCTAssert(false, "Endpoint failed with error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if os(iOS)
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #else
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
