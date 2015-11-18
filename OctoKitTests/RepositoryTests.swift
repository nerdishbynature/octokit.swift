import XCTest
import OctoKit
import Nocilla

class RepositoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

    // MARK: URLRequest Tests

    func testReadRepositoriesURLRequest() {
        let kit = Octokit(TokenConfiguration())
        let request = RepositoryRouter.ReadRepositories(kit.configuration, "octocat", "1", "100").URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/users/octocat/repos?page=1&per_page=100")!)
    }

    func testReadRepositoriesURLRequestWithCustomPageAndPerPage() {
        let kit = Octokit(TokenConfiguration())
        let request = RepositoryRouter.ReadRepositories(kit.configuration, "octocat", "5", "50").URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/users/octocat/repos?page=5&per_page=50")!)
    }

    func testReadAuthenticatedRepositoriesURLRequest() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = RepositoryRouter.ReadAuthenticatedRepositories(kit.configuration, "1", "100").URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/user/repos?access_token=12345&page=1&per_page=100")!)
    }

    func testReadAuthenticatedRepositoriesURLRequestWithCustomPageAndPerPage() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = RepositoryRouter.ReadAuthenticatedRepositories(kit.configuration, "5", "50").URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/user/repos?access_token=12345&page=5&per_page=50")!)
    }

    func testReadRepositoryURLRequest() {
        let request = RepositoryRouter.ReadRepository(Octokit().configuration, "mietzmithut", "Test").URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/repos/mietzmithut/Test")!)
    }

    // MARK: Actual Request tests

    func testGetRepositories() {
        if let json = Helper.stringFromFile("user_repos") {
            stubRequest("GET", "https://api.github.com/users/octocat/repos?page=1&per_page=100").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_repos")
            Octokit().repositories("octocat") { response in
                switch response {
                case .Success(let repositories):
                    XCTAssertEqual(repositories.count, 1)
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an error")
                    expectation.fulfill()
                }
            }
            waitForExpectationsWithTimeout(1) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }

    func testGetAuthenticatedRepositories() {
        let config = TokenConfiguration("12345")
        if let json = Helper.stringFromFile("user_repos") {
            stubRequest("GET", "https://api.github.com/user/repos?access_token=12345&page=1&per_page=100").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_repos")
            Octokit(config).repositories() { response in
                switch response {
                case .Success(let repositories):
                    XCTAssertEqual(repositories.count, 1)
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an error")
                    expectation.fulfill()
                }
            }
            waitForExpectationsWithTimeout(1) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }

    func testFailToGetRepositories() {
        let config = TokenConfiguration("12345")
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        stubRequest("GET", "https://api.github.com/user/repos?access_token=12345&page=1&per_page=100").andReturn(401).withHeaders(["Content-Type": "application/json"]).withBody(json)
        let expectation = expectationWithDescription("failing_repos")
        Octokit(config).repositories() { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
                expectation.fulfill()
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, "com.octokit.swift")
                expectation.fulfill()
            case .Failure:
                XCTAssertTrue(false)
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testGetRepository() {
        let (owner, name) = ("mietzmithut", "Test")
        if let json = Helper.stringFromFile("repo") {
            stubRequest("GET", "https://api.github.com/repos/mietzmithut/Test").andReturn(200)
                .withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("repo")
            Octokit().repository(owner, name: name) { response in
                switch response {
                case .Success(let repo):
                    XCTAssertEqual(repo.name!, name)
                    XCTAssertEqual(repo.owner.login!, owner)
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an error")
                    expectation.fulfill()
                }
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testFailToGetRepository() {
        stubRequest("GET", "https://api.github.com/repos/mietzmithut/Test").andReturn(404)
        let expectation = expectationWithDescription("failing_repo")
        let (owner, name) = ("mietzmithut", "Test")
        Octokit().repository(owner, name: name) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
                expectation.fulfill()
            case .Failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, "com.octokit.swift")
                expectation.fulfill()
            case .Failure:
                XCTAssertTrue(false)
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    // MARK: Model Tests

    func testUserParsingFullRepository() {
        let subject = Repository(Helper.JSONFromFile("repo") as! [String: AnyObject])
        XCTAssertEqual(subject.owner.login!, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4672699)

        XCTAssertEqual(subject.id, 10824973)
        XCTAssertEqual(subject.name!, "Test")
        XCTAssertEqual(subject.fullName!, "mietzmithut/Test")
        XCTAssertEqual(subject.isPrivate, false)
        XCTAssertEqual(subject.repositoryDescription, "")
        XCTAssertEqual(subject.isFork!, false)
        XCTAssertEqual(subject.gitURL!, "git://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.sshURL!, "git@github.com:mietzmithut/Test.git")
        XCTAssertEqual(subject.cloneURL!, "https://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.size, 132)
    }
}
