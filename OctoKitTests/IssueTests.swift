import XCTest
import OctoKit

class IssueTests: XCTestCase {
    // MARK: Actual Request tests
    
    func testGetMyIssues() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/issues?access_token=12345&page=1&per_page=100&state=open", expectedHTTPMethod: "GET", jsonFile: "issues", statusCode: 200)
        let task = Octokit(config).myIssues(session) { response in
            switch response {
            case .success(let issues):
                XCTAssertEqual(issues.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetIssue() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1347", expectedHTTPMethod: "GET", jsonFile: "issue", statusCode: 200)
        let task = Octokit().issue(session, owner: "octocat", repository: "Hello-World", number: 1347) { response in
            switch response {
            case .success(let issue):
                XCTAssertEqual(issue.number, 1347)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests
    
    func testParsingIssue() {
        let subject = Issue(Helper.JSONFromFile("issue") as! [String: AnyObject])
        XCTAssertEqual(subject.user?.login, "octocat")
        XCTAssertEqual(subject.user?.id, 1)
        
        XCTAssertEqual(subject.id, 1)
        XCTAssertEqual(subject.number, 1347)
        XCTAssertEqual(subject.title, "Found a bug")
        XCTAssertEqual(subject.htmlURL, URL(string: "https://github.com/octocat/Hello-World/issues/1347"))
        XCTAssertEqual(subject.state, Openness.Open)
        XCTAssertEqual(subject.locked, false)
    }
}
