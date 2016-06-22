import XCTest
import OctoKit

class RepositoryTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        Octokit().repositories(session, owner: "octocat") { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAuthenticatedRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?access_token=12345&page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let config = TokenConfiguration("12345")
        Octokit(config).repositories(session) { response in
            switch response {
            case .Success(let repositories):
                XCTAssertEqual(repositories.count, 1)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepositories() {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?access_token=12345&page=1&per_page=100", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        let config = TokenConfiguration("12345")
        Octokit(config).repositories(session) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, "com.octokit.swift")
            case .Failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepository() {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        Octokit().repository(session, owner: owner, name: name) { response in
            switch response {
            case .Success(let repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepository() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let (owner, name) = ("mietzmithut", "Test")
        Octokit().repository(session, owner: owner, name: name) { response in
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

    // MARK: Model Tests

    func testUserParsingFullRepository() {
        let subject = Repository(Helper.JSONFromFile("repo") as! [String: AnyObject])
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
