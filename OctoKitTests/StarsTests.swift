import XCTest
import OctoKit
import Nocilla

class StarsTests: XCTestCase {

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

    func testReadStarsURLRequest() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = StarsRouter.ReadStars("octocat", kit).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/users/octocat/starred?access_token=12345")!)
    }

    func testMyStarsURLRequest() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = StarsRouter.ReadAuthenticatedStars(kit).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/user/starred?access_token=12345")!)
    }

    // MARK: Actual Request tests

    func testGetStarredRepositories() {
        let config = TokenConfiguration("12345")
        if let json = Helper.stringFromFile("user_repos") {
            stubRequest("GET", "https://api.github.com/user/starred?access_token=12345").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_starred")
            Octokit(config).myStars() { response in
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

    func testFailToGetStarredRepositories() {
        let config = TokenConfiguration("12345")
        stubRequest("GET", "https://api.github.com/user/starred?access_token=12345").andReturn(404)
        let expectation = expectationWithDescription("failing_starred")
        Octokit(config).myStars() { response in
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

    func testGetUsersStarredRepositories() {
        if let json = Helper.stringFromFile("user_repos") {
            stubRequest("GET", "https://api.github.com/users/octocat/starred").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("users_starred")
            Octokit().stars("octocat") { response in
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

    func testFailToGetUsersStarredRepositories() {
        stubRequest("GET", "https://api.github.com/users/octocat/starred").andReturn(404)
        let expectation = expectationWithDescription("failing_starred")
        Octokit().stars("octocat") { response in
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
}