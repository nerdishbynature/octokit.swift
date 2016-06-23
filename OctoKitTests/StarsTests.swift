import XCTest
import OctoKit

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred?access_token=12345", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let config = TokenConfiguration("12345")
        let task = Octokit(config).myStars(session) { response in
            switch response {
            case .success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetStarredRepositories() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred?access_token=12345", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(config).myStars(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
