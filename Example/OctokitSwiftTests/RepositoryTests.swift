import XCTest
import Nocilla
import Octokit

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

    func testReadingUserURLRequest() {
        let kit = Octokit(TokenConfiguration(token: "12345"))
        let request = RepositoryRouter.ReadRepositories(kit).URLRequest
        XCTAssertEqual(request.URL, NSURL(string: "https://api.github.com/user/repos?access_token=12345")!)
    }

    // MARK: Actual Request tests

    func testGetRepositories() {
        let config = TokenConfiguration(token: "12345")
        if let json = Helper.stringFromFile("user_repos") {
            stubRequest("GET", "https://api.github.com/user/repos?access_token=12345").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_repos")
            Octokit(config).repositories() { response in
                switch response {
                case .Success(let repositories):
                    XCTAssertEqual(repositories.count, 1)
                    expectation.fulfill()
                case .Failure(let error):
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

    func testFailToGetAuthenticatedUser() {
        let config = TokenConfiguration(token: "12345")
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        stubRequest("GET", "https://api.github.com/user/repos?access_token=12345").andReturn(401).withHeaders(["Content-Type": "application/json"]).withBody(json)
        let expectation = expectationWithDescription("failing_repos")
        Octokit(config).repositories() { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve repositories")
                expectation.fulfill()
            case .Failure(let error):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, "com.octokit.swift")
                expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(1) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    // MARK: Model Tests

    func testUserParsingFullRepository() {
        let repoJSON = Helper.JSONFromFile("user_repos") as [[String:AnyObject]]
        let subject = Repository(repoJSON.first!)
        XCTAssertEqual(subject.owner.login, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4672699)

        XCTAssertEqual(subject.name, "Test")
    }

}