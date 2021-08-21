import OctoKit
import XCTest

class IssueTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyIssues() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/issues?page=1&per_page=100&state=open",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "issues",
            statusCode: 200
        )
        let task = Octokit(config).myIssues(session) { response in
            switch response {
            case let .success(issues):
                XCTAssertEqual(issues.count, 1)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetIssue() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1347", expectedHTTPMethod: "GET", jsonFile: "issue", statusCode: 200)
        let task = Octokit().issue(session, owner: "octocat", repository: "Hello-World", number: 1347) { response in
            switch response {
            case let .success(issue):
                XCTAssertEqual(issue.number, 1347)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testPostIssue() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues", expectedHTTPMethod: "POST", jsonFile: "issue2", statusCode: 200)
        let task = Octokit().postIssue(session, owner: "octocat", repository: "Hello-World", title: "Title", body: "Body") { response in
            switch response {
            case let .success(issue):
                XCTAssertEqual(issue.number, 36)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testPostComment() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1/comments", expectedHTTPMethod: "POST", jsonFile: "issue_comment", statusCode: 201)
        let task = Octokit().commentIssue(session, owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment") { response in
            switch response {
            case let .success(comment):
                XCTAssertEqual(comment.body, "Testing a comment")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testCommentsIssue() {
        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1/comments?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            jsonFile: "issue_comments",
            statusCode: 200
        )
        let task = Octokit().issueComments(session, owner: "octocat", repository: "Hello-World", number: 1) { response in
            switch response {
            case let .success(comments):
                XCTAssertEqual(comments.count, 1)
                XCTAssertEqual(comments[0].body, "Testing fetching comments for an issue")
                XCTAssertEqual(comments[0].reactions!.totalCount, 5)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testParsingIssue() {
        let subject = Helper.codableFromFile("issue", type: Issue.self)
        XCTAssertEqual(subject.user?.login, "octocat")
        XCTAssertEqual(subject.user?.id, 1)

        XCTAssertEqual(subject.id, 1)
        XCTAssertEqual(subject.number, 1347)
        XCTAssertEqual(subject.title, "Found a bug")
        XCTAssertEqual(subject.htmlURL, URL(string: "https://github.com/octocat/Hello-World/issues/1347"))
        XCTAssertEqual(subject.state, Openness.open)
        XCTAssertEqual(subject.locked, false)
    }

    func testParsingIssue2() {
        let subject = Helper.codableFromFile("issue2", type: Issue.self)
        XCTAssertEqual(subject.user?.login, "vincode-io")
        XCTAssertEqual(subject.user?.id, 16448027)

        XCTAssertEqual(subject.id, 427231234)
        XCTAssertEqual(subject.number, 36)
        XCTAssertEqual(subject.title, "Add Request: Test File")
        XCTAssertEqual(subject.htmlURL, URL(string: "https://github.com/vincode-io/FeedCompass/issues/36"))
        XCTAssertEqual(subject.state, Openness.open)
        XCTAssertEqual(subject.locked, false)
    }
}
