import OctoKit
import XCTest

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_repos", statusCode: 200)
        let task = Octokit(config, session: session).myStars { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetStarredRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: nil, statusCode: 404)
        let task = Octokit(config, session: session).myStars { response in
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
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit(session: session).stars(name: "octocat") { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersStarredRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(session: session).stars(name: "octocat") { response in
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

    func testGetStarFromNotStarredRepository() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(session: session).star(owner: "octocat", repository: "Hello-World") { response in
            switch response {
            case let .success(flag):
                XCTAssertFalse(flag)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarFromStarredRepository() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 204)
        let task = Octokit(session: session).star(owner: "octocat", repository: "Hello-World") { response in
            switch response {
            case let .success(flag):
                XCTAssertTrue(flag)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testPutStar() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "PUT", jsonFile: nil, statusCode: 204)
        let task = Octokit(session: session).putStar(owner: "octocat", repository: "Hello-World") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testDeleteStar() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "DELETE", jsonFile: nil, statusCode: 204)
        let task = Octokit(session: session).deleteStar(owner: "octocat", repository: "Hello-World") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension StarsTests {
    func testGetStarredRepositoriesAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(config, session: session).myStars()
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersStarredRepositoriesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(session: session).stars(name: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarFromNotStarredRepositoryAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertFalse(flag)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarFromStarredRepositoryAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 204)
        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(flag)
        XCTAssertTrue(session.wasCalled)
    }

    func testPutStarAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "PUT", jsonFile: nil, statusCode: 204)
        try await Octokit(session: session).putStar(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(session.wasCalled)
    }

    func testDeleteStarAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "DELETE", jsonFile: nil, statusCode: 204)
        try await Octokit(session: session).deleteStar(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(session.wasCalled)
    }
}
#endif
