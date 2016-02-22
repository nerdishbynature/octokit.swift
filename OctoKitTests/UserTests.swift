import XCTest
import OctoKit
import Nocilla

class UserTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

    // MARK: Actual Request tests

    func testGetUser() {
        let username = "mietzmithut"
        if let json = Helper.stringFromFile("user_mietzmithut") {
            stubRequest("GET", "https://api.github.com/users/mietzmithut").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("\(username)")
            Octokit().user(username) { response in
                switch response {
                case .Success(let user):
                    XCTAssertEqual(user.login!, username)
                    expectation.fulfill()
                case .Failure:
                    XCTAssert(false, "should not get an user")
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

    func testFailingToGetUser() {
        let username = "notexisting"
        stubRequest("GET", "https://api.github.com/users/notexisting").andReturn(404)
        let expectation = expectationWithDescription("\(username)")
        Octokit().user(username) { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve user")
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
        waitForExpectationsWithTimeout(1) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testGettingAuthenticatedUser() {
        if let json = Helper.stringFromFile("user_me") {
            stubRequest("GET", "https://api.github.com/user?access_token=token").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("me")
            Octokit(TokenConfiguration("token")).me() { response in
                switch response {
                case .Success(let user):
                    XCTAssertEqual(user.login!, "pietbrauer")
                    expectation.fulfill()
                case .Failure(let error):
                    XCTAssert(false, "should not retrieve an error \(error)")
                }
            }
            waitForExpectationsWithTimeout(10) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }

    func testFailToGetAuthenticatedUser() {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        stubRequest("GET", "https://api.github.com/user").andReturn(401).withHeaders(["Content-Type": "application/json"]).withBody(json)
        let expectation = expectationWithDescription("failing_me")
        Octokit().me() { response in
            switch response {
            case .Success:
                XCTAssert(false, "should not retrieve user")
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

    // MARK: Model Tests

    func testUserParsingFullUser() {
        let subject = User(Helper.JSONFromFile("user_me") as! [String: AnyObject])
        XCTAssertEqual(subject.login!, "pietbrauer")
        XCTAssertEqual(subject.id, 759730)
        XCTAssertEqual(subject.avatarURL!, "https://avatars.githubusercontent.com/u/759730?v=3")
        XCTAssertEqual(subject.gravatarID!, "")
        XCTAssertEqual(subject.type!, "User")
        XCTAssertEqual(subject.name!, "Piet Brauer")
        XCTAssertEqual(subject.company!, "XING AG")
        XCTAssertEqual(subject.blog!, "xing.to/PietBrauer")
        XCTAssertEqual(subject.location!, "Hamburg")
        XCTAssertNil(subject.email)
        XCTAssertEqual(subject.numberOfPublicRepos!, 6)
        XCTAssertEqual(subject.numberOfPublicGists!, 10)
        XCTAssertEqual(subject.numberOfPrivateRepos!, 4)
    }

    func testUserParsingMinimalUser() {
        let subject = User(Helper.JSONFromFile("user_mietzmithut") as! [String: AnyObject])
        XCTAssertEqual(subject.login!, "mietzmithut")
        XCTAssertEqual(subject.id, 4672699)
        XCTAssertEqual(subject.avatarURL!, "https://avatars.githubusercontent.com/u/4672699?v=3")
        XCTAssertEqual(subject.gravatarID!, "")
        XCTAssertEqual(subject.type!, "User")
        XCTAssertEqual(subject.name!, "Julia Kallenberg")
        XCTAssertEqual(subject.company!, "")
        XCTAssertEqual(subject.blog!, "")
        XCTAssertEqual(subject.location!, "Hamburg")
        XCTAssertEqual(subject.email!, "")
        XCTAssertEqual(subject.numberOfPublicRepos!, 7)
        XCTAssertEqual(subject.numberOfPublicGists!, 0)
        XCTAssertNil(subject.numberOfPrivateRepos)
    }
}
