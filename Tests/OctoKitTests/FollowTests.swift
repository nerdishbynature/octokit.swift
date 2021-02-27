import XCTest
import OctoKit

class FollowTests: XCTestCase {
    func testGetMyFollowers() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "users", statusCode: 200)
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
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: nil, statusCode: 404)
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
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "users", statusCode: 200)
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
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: nil, statusCode: 404)
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
}
