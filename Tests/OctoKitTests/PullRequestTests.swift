import XCTest
import OctoKit

class PullRequestTests: XCTestCase {
    static var allTests = [
        ("testGetPullRequest", testGetPullRequest),
        ("testGetPullRequests", testGetPullRequests),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func testGetPullRequest() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                expectedHTTPMethod: "GET",
                jsonFile: "pull_request",
                statusCode: 200
        )

        let task = Octokit().pullRequest(session, owner: "octocat", repository: "Hello-World", number: 1) { response in
            switch response {
            case .success(let pullRequests):
                XCTAssertEqual(pullRequests.id, 1)
                XCTAssertEqual(pullRequests.title, "new-feature")
                XCTAssertEqual(pullRequests.body, "Please pull these awesome changes")
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetPullRequests() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?base=develop&direction=desc&sort=created&state=open",
                expectedHTTPMethod: "GET",
                jsonFile: "pull_requests",
                statusCode: 200
        )

        let task = Octokit().pullRequests(session, owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.Open) { response in
            switch response {
            case .success(let pullRequests):
                XCTAssertEqual(pullRequests.count, 1)
                XCTAssertEqual(pullRequests.first?.title, "new-feature")
                XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if os(iOS)
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #else
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
