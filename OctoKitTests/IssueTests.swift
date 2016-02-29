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
        if let json = Helper.stringFromFile("issue") {
            stubRequest("GET", "https://api.github.com/user/issues?access_token=12345").andReturn(200).withHeaders(["Content-Type": "application/json"]).withBody(json)
            let expectation = expectationWithDescription("user_issues")
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
}