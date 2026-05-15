import OctoKit
import XCTest

class IssueEventTests: XCTestCase {
    // MARK: Actual Request Tests

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetIssueEvents() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/1/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_events",
                                            statusCode: 200)
        let events = try await Octokit(session: session).issueEvents(owner: "nerdishbynature", repository: "octokit.swift", issueNumber: 1)
        XCTAssertEqual(events.count, 6)
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoryIssueEvents() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_repo_events",
                                            statusCode: 200)
        let events = try await Octokit(session: session).repositoryIssueEvents(owner: "nerdishbynature", repository: "octokit.swift")
        XCTAssertFalse(events.isEmpty)
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetIssueEvent() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/events/218585596",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_event",
                                            statusCode: 200)
        let event = try await Octokit(session: session).issueEvent(owner: "nerdishbynature", repository: "octokit.swift", id: 218585596)
        XCTAssertEqual(event.id, 218585596)
        XCTAssertEqual(event.event, "head_ref_force_pushed")
        XCTAssertEqual(event.actor?.login, "pietbrauer")
        XCTAssertEqual(event.commitId, "f3f149bee52170170bf5b083db5b10ca1f98fc43")
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Parsing Tests

    func testParsingIssueEvent() {
        let event = Helper.codableFromFile("issue_event", type: IssueEvent.self)
        XCTAssertEqual(event.id, 218585596)
        XCTAssertEqual(event.event, "head_ref_force_pushed")
        XCTAssertEqual(event.actor?.login, "pietbrauer")
        XCTAssertEqual(event.commitId, "f3f149bee52170170bf5b083db5b10ca1f98fc43")
        XCTAssertNotNil(event.createdAt)
    }
}
