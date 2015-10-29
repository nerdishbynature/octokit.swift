import XCTest
import OctoKit
import Nocilla

class FollowTests: XCTestCase {
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

    func testReadingUserFollowersURLRequest() {
        let kit = Octokit()
        let request = FollowRouter.ReadFollowers("octocat", kit.configuration).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/users/octocat/followers")!)
    }

    func testReadingAuthenticatedUserFollowersURLRequest() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = FollowRouter.ReadAuthenticatedFollowers(kit.configuration).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/user/followers?access_token=12345")!)
    }

    func testReadingUserFollowingURLRequest() {
        let kit = Octokit()
        let request = FollowRouter.ReadFollowing("octocat", kit.configuration).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/users/octocat/following")!)
    }

    func testReadingAuthenticatedUserFollowingURLRequest() {
        let kit = Octokit(TokenConfiguration("12345"))
        let request = FollowRouter.ReadAuthenticatedFollowing(kit.configuration).URLRequest
        XCTAssertEqual(request!.URL!, NSURL(string: "https://api.github.com/user/following?access_token=12345")!)
    }
    
    // MARK: Actual Request tests

    func testGetMyFollowers() {
        let config = TokenConfiguration("12345")
        if let json = Helper.stringFromFile("users") {
            stubRequest("GET", "https://api.github.com/user/followers?access_token=12345").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_followers")
            Octokit(config).myFollowers() { response in
                switch response {
                case .Success(let users):
                    XCTAssertEqual(users.count, 1)
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

    func testFailToGetMyFollowers() {
        let config = TokenConfiguration("12345")
        stubRequest("GET", "https://api.github.com/user/followers?access_token=12345").andReturn(404)
        let expectation = expectationWithDescription("failing_my_followers")
        Octokit(config).myFollowers() { response in
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
