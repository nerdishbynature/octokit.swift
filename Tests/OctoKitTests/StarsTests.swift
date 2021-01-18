import OctoKit
import XCTest

class StarsTests: XCTestCase {
    static var allTests = [
        ("testGetStarredRepositories", testGetStarredRepositories),
        ("testFailToGetStarredRepositories", testFailToGetStarredRepositories),
        ("testGetUsersStarredRepositories", testGetUsersStarredRepositories),
        ("testFailToGetUsersStarredRepositories", testFailToGetUsersStarredRepositories),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/user/starred",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "user_repos",
            statusCode: 200
        )
        let task = Octokit(config).myStars(session) { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetStarredRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/user/starred",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: nil,
            statusCode: 404
        )
        let task = Octokit(config).myStars(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/users/octocat/starred",
            expectedHTTPMethod: "GET",
            jsonFile: "user_repos",
            statusCode: 200
        )
        let task = Octokit().stars(session, name: "octocat") { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/users/octocat/starred",
            expectedHTTPMethod: "GET",
            jsonFile: nil,
            statusCode: 404
        )
        let task = Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
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
