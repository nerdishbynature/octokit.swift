import OctoKit
import XCTest

class IssueEventTests: XCTestCase {
    // MARK: Actual Request Tests

    func testGetIssueEvents() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/1/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_events",
                                            statusCode: 200)
        let task = Octokit(session: session).issueEvents(owner: "nerdishbynature", repository: "octokit.swift", issueNumber: 1) { response in
            switch response {
            case let .success(events):
                XCTAssertEqual(events.count, 6)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetIssueEventsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/1/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_events",
                                            statusCode: 200)
        let events = try await Octokit(session: session).issueEvents(owner: "nerdishbynature", repository: "octokit.swift", issueNumber: 1)
        XCTAssertEqual(events.count, 6)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetRepositoryIssueEvents() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_repo_events",
                                            statusCode: 200)
        let task = Octokit(session: session).repositoryIssueEvents(owner: "nerdishbynature", repository: "octokit.swift") { response in
            switch response {
            case let .success(events):
                XCTAssertFalse(events.isEmpty)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoryIssueEventsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/events?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_repo_events",
                                            statusCode: 200)
        let events = try await Octokit(session: session).repositoryIssueEvents(owner: "nerdishbynature", repository: "octokit.swift")
        XCTAssertFalse(events.isEmpty)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetIssueEvent() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/issues/events/218585596",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_event",
                                            statusCode: 200)
        let task = Octokit(session: session).issueEvent(owner: "nerdishbynature", repository: "octokit.swift", id: 218585596) { response in
            switch response {
            case let .success(event):
                XCTAssertEqual(event.id, 218585596)
                XCTAssertEqual(event.event, "head_ref_force_pushed")
                XCTAssertEqual(event.actor?.login, "pietbrauer")
                XCTAssertEqual(event.commitId, "f3f149bee52170170bf5b083db5b10ca1f98fc43")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetIssueEventAsync() async throws {
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
    #endif

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
