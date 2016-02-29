import XCTest
import OctoKit
import Nocilla

class IssueTests: XCTestCase {
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
    
    func testGetMyIssues() {
        let config = TokenConfiguration("12345")
        if let json = Helper.stringFromFile("issues") {
            stubRequest("GET", "https://api.github.com/issues?access_token=12345&page=1&per_page=100").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("issues")
            Octokit(config).myIssues() { response in
                switch response {
                case .Success(let issues):
                    XCTAssertEqual(issues.count, 1)
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
    
    func testGetIssue() {
        let (owner, repo, number) = ("octocat", "Hello-World", 1347)
        if let json = Helper.stringFromFile("issue") {
            stubRequest("GET", "https://api.github.com/repos/octocat/Hello-World/issues/1347").andReturn(200)
                .withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("issue")
            Octokit().issue(owner, repository: repo, number: number) { response in
                switch response {
                case .Success(let issue):
                    XCTAssertEqual(issue.number!, number)
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
    
    // MARK: Model Tests
    
    func testParsingIssue() {
        let subject = Issue(Helper.JSONFromFile("issue") as! [String: AnyObject])
        XCTAssertEqual(subject.user!.login!, "octocat")
        XCTAssertEqual(subject.user!.id, 1)
        
        XCTAssertEqual(subject.id, 1)
        XCTAssertEqual(subject.number!, 1347)
        XCTAssertEqual(subject.title!, "Found a bug")
        XCTAssertEqual(subject.htmlURL, NSURL(string: "https://github.com/octocat/Hello-World/issues/1347"))
        XCTAssertEqual(subject.state!, IssueState.Open)
        XCTAssertEqual(subject.locked!, false)
    }
}
