import XCTest
import Nocilla
import Octokit

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

    func testReadingUserURLRequest() {
        let kit = Octokit()
        let request = UserRouter.ReadUser("mietzmithut", kit).URLRequest
        XCTAssertEqual(request.URL, NSURL(string: "https://api.github.com/users/mietzmithut")!)
    }

    func testReadingAuthenticatedUserURLRequest() {
        let kit = Octokit(TokenConfiguration(token: "12345"))
        let request = UserRouter.ReadAuthenticatedUser(kit).URLRequest
        XCTAssertEqual(request.URL, NSURL(string: "https://api.github.com/user?access_token=12345")!)
    }

    func testGettingUser() {
        let username = "mietzmithut"
        if let json = Helper.jsonFromFile("user_mietzmithut") {
            stubRequest("GET", "https://api.github.com/users/mietzmithut").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("\(username)")
            Octokit().user(username) { user in
                XCTAssertEqual(user.login, username)
                expectation.fulfill()
            }
            waitForExpectationsWithTimeout(1) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }

    func testGettingAuthenticatedUser() {
        if let json = Helper.jsonFromFile("user_me") {
            stubRequest("GET", "https://api.github.com/user?access_token=token").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("me")
            Octokit().me() { user in
                XCTAssertEqual(user.login, "pietbrauer")
                expectation.fulfill()
            }
            waitForExpectationsWithTimeout(10) { (error) in
                XCTAssertNil(error, "\(error)")
            }
        } else {
            XCTFail("json shouldn't be nil")
        }
    }
}
