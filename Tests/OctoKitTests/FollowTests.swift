import XCTest
import OctoKit

class FollowTests: XCTestCase {
    static var allTests = [
        ("testGetMyFollowers", testGetMyFollowers),
        ("testFailToGetMyFollowers", testFailToGetMyFollowers),
        ("testGetUsersFollowers", testGetUsersFollowers),
        ("testFailToGetUsersFollowers", testFailToGetUsersFollowers),
        ("testGetMyFollowing", testGetMyFollowing),
        ("testFailToGetMyFollowing", testFailToGetMyFollowing),
        ("testGetUsersFollowing", testGetUsersFollowing),
        ("testFailToGetUsersFollowing", testFailToGetUsersFollowing),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func testGetMyFollowers() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let task = Octokit(config).myFollowers(session) { response in
            switch response {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetMyFollowers() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(config).myFollowers(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve followers")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowers() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/followers", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let task = Octokit().followers(session, name: "octocat") { response in
            switch response {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersFollowers() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/followers", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit().followers(session, name: "octocat") { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve followers")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetMyFollowing() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let config = TokenConfiguration("12345")
        let task = Octokit(config).myFollowing(session) { response in
            switch response {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetMyFollowing() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(config).myFollowing(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve following")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowing() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/following", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let task = Octokit().following(session, name: "octocat") { response in
            switch response {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersFollowing() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/following", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit().following(session, name: "octocat") { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve following")
            case .failure(let error as NSError):
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
        let darwinCount = thisClass.defaultTestSuite().tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
