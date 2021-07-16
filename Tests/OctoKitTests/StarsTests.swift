import XCTest
import OctoKit

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_repos", statusCode: 200)
        let task = Octokit(config).myStars(session) { response in
            switch response {
            case .success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking) && !os(macOS)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetStarredRepositoriesAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(config).myStars(session)
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit().stars(session, name: "octocat") { response in
            switch response {
            case .success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking) && !os(macOS)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetUsersStarredRepositoriesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit().stars(session, name: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
