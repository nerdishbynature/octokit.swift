import XCTest
import OctoKit

class FollowTests: XCTestCase {
    func testGetMyFollowers() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        Octokit(config).myFollowers(session) { response in
            switch response {
            case .Success(let users):
                XCTAssertEqual(users.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetMyFollowers() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        Octokit(config).myFollowers(session) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve followers")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowers() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/followers", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        Octokit().followers(session, name: "octocat") { response in
            switch response {
            case .Success(let users):
                XCTAssertEqual(users.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersFollowers() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/followers", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        Octokit().followers(session, name: "octocat") { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve followers")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetMyFollowing() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let config = TokenConfiguration("12345")
        Octokit(config).myFollowing(session) { response in
            switch response {
            case .Success(let users):
                XCTAssertEqual(users.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetMyFollowing() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(config).myFollowing(session) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve following")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowing() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/following", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let task = Octokit().following(session, name: "octocat") { response in
            switch response {
            case .Success(let users):
                XCTAssertEqual(users.count, 1)
            case .Failure:
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
            case .Success:
                XCTAssert(false, "should not retrieve following")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
