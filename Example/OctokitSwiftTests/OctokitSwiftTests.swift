import XCTest
import Octokit
import Nocilla

let enterpriseURL = "https://enterprise.myserver.com"

class OctokitSwiftTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

    func testConfigurationBaseURL() {
        let subject = Configuration(token: "12345")
        XCTAssertEqual(subject.serverType, Server.Github)
        XCTAssertEqual(subject.accessToken, "12345")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testEnterpriseConfigurationBaseURL() {
        let subject = Configuration(enterpriseURL, token: "12345")
        XCTAssertEqual(subject.serverType, Server.Enterprise)
        XCTAssertEqual(subject.accessToken, "12345")
    }

    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://api.github.com")
    }

    func testOctokitInitializerWithConfig() {
        let config = Configuration(enterpriseURL, token: "12345")
        let subject = Octokit(config)
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://enterprise.myserver.com")
    }

    func testReadingUserURLRequest() {
        let kit = Octokit()
        let request = Router.ReadUser("mietzmithut", kit).URLRequest
        XCTAssertEqual(request.URL, NSURL(string: "https://api.github.com/users/mietzmithut")!)
    }

    func testReadingAuthenticatedUserURLRequest() {
        let kit = Octokit(Configuration(token: "12345"))
        let request = Router.ReadAuthenticatedUser(kit).URLRequest
        XCTAssertEqual(request.URL, NSURL(string: "https://api.github.com/user?access_token=12345")!)
    }

    func testGettingUser() {
        let username = "mietzmithut"
        if let json = jsonFromFile("user_mietzmithut") {
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
        if let json = jsonFromFile("user_me") {
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

    func jsonFromFile(name: String) -> String? {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(name, ofType: "json")
        if let path = path {
            let string = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
            return string
        }
        return nil
    }
}