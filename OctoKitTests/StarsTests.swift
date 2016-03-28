import XCTest
import OctoKit

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let config = TokenConfiguration("12345")
        Octokit(config).myStars(session) { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetStarredRepositories() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        Octokit(config).myStars(session) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, "com.octokit.swift")
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, "com.octokit.swift")
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}