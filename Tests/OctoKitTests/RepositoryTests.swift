import XCTest
import OctoKit

class RepositoryTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit().repositories(session, owner: "octocat") { response in
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
            case .success(let repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking) && !os(macOS)
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
        XCTAssertEqual(subject.owner.id, 4672699)

        XCTAssertEqual(subject.id, 10824973)
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
