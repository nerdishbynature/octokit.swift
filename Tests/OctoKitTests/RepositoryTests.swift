import OctoKit
import XCTest

class RepositoryTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit().repositories(session, owner: "octocat") { response in
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

    func testGetRepositoriesEnterprise() {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let session = OctoKitURLTestSession(
            expectedURL: "https://enterprise.nerdishbynature.com/api/v3/users/octocat/repos?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            jsonFile: "user_repos",
            statusCode: 200
        )
        let task = Octokit(config).repositories(session, owner: "octocat") { response in
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

    func testGetAuthenticatedRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "user_repos",
            statusCode: 200
        )
        let task = Octokit(config).repositories(session) { response in
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

    func testGetAuthenticatedRepositoriesEnterprise() {
        let config = TokenConfiguration("user:12345", url: "https://enterprise.nerdishbynature.com/api/v3/")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://enterprise.nerdishbynature.com/api/v3/user/repos?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "user_repos",
            statusCode: 200
        )
        let task = Octokit(config).repositories(session) { response in
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

    func testFailToGetRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            response: json,
            statusCode: 401
        )
        let task = Octokit(config).repositories(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoriesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit().repositories(session, owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetRepository() {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let task = Octokit().repository(session, owner: owner, name: name) { response in
            switch response {
            case let .success(repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoryEnterprise() {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let task = Octokit(config).repository(session, owner: owner, name: name) { response in
            switch response {
            case let .success(repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepository() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let (owner, name) = ("mietzmithut", "Test")
        let task = Octokit().repository(session, owner: owner, name: name) { response in
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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoryAsync() async throws {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let repo = try await Octokit().repository(session, owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Model Tests

    func testUserParsingFullRepository() {
        let subject = Helper.codableFromFile("repo", type: Repository.self)
        XCTAssertEqual(subject.owner.login, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4_672_699)

        XCTAssertEqual(subject.id, 10_824_973)
        XCTAssertEqual(subject.name, "Test")
        XCTAssertEqual(subject.fullName, "mietzmithut/Test")
        XCTAssertEqual(subject.isPrivate, false)
        XCTAssertEqual(subject.repositoryDescription, "")
        XCTAssertEqual(subject.isFork, false)
        XCTAssertEqual(subject.gitURL, "git://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.sshURL, "git@github.com:mietzmithut/Test.git")
        XCTAssertEqual(subject.cloneURL, "https://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.size, 132)
    }
}
