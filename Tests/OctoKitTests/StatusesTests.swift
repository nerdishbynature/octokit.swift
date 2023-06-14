import OctoKit
import XCTest

class StatusesTests: XCTestCase {
    // MARK: Actual Request tests

    func testCreateCommitStatus() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "status",
                                            statusCode: 201)

        let task = Octokit(session: session).createCommitStatus(owner: "octocat",
                                                                repository: "Hello-World",
                                                                sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                                                state: .success,
                                                                targetURL: "https://example.com/build/status",
                                                                description: "The build succeeded!",
                                                                context: "continuous-integration/jenkins") { response in
            switch response {
            case let .success(status):
                XCTAssertEqual(status.id, 1)
                XCTAssertEqual(status.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(status.avatarURL, "https://github.com/images/error/hubot_happy.gif")
                XCTAssertEqual(status.nodeId, "MDY6U3RhdHVzMQ==")
                XCTAssertEqual(status.state, Status.State.success)
                XCTAssertEqual(status.description, "Build has completed successfully")
                XCTAssertEqual(status.targetURL, "https://ci.example.com/1000/output")
                XCTAssertEqual(status.context, "continuous-integration/jenkins")
                XCTAssertEqual(status.creator?.login, "octocat")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testCreateCommitStatusAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "status",
                                            statusCode: 201)

        let status = try await Octokit(session: session).createCommitStatus(owner: "octocat",
                                                                            repository: "Hello-World",
                                                                            sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                                                            state: .success,
                                                                            targetURL: "https://example.com/build/status",
                                                                            description: "The build succeeded!",
                                                                            context: "continuous-integration/jenkins")
        XCTAssertEqual(status.id, 1)
        XCTAssertEqual(status.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(status.avatarURL, "https://github.com/images/error/hubot_happy.gif")
        XCTAssertEqual(status.nodeId, "MDY6U3RhdHVzMQ==")
        XCTAssertEqual(status.state, Status.State.success)
        XCTAssertEqual(status.description, "Build has completed successfully")
        XCTAssertEqual(status.targetURL, "https://ci.example.com/1000/output")
        XCTAssertEqual(status.context, "continuous-integration/jenkins")
        XCTAssertEqual(status.creator?.login, "octocat")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testListCommitStatuses() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/statuses",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "statuses",
                                            statusCode: 200)

        let task = Octokit(session: session).listCommitStatuses(owner: "octocat", repository: "Hello-World", ref: "6dcb09b5b57875f334f61aebed695e2e4193db5e") { response in
            switch response {
            case let .success(statuses):
                XCTAssertEqual(statuses.count, 1)
                XCTAssertEqual(statuses.first?.id, 1)
                XCTAssertEqual(statuses.first?.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(statuses.first?.avatarURL, "https://github.com/images/error/hubot_happy.gif")
                XCTAssertEqual(statuses.first?.nodeId, "MDY6U3RhdHVzMQ==")
                XCTAssertEqual(statuses.first?.state, Status.State.success)
                XCTAssertEqual(statuses.first?.description, "Build has completed successfully")
                XCTAssertEqual(statuses.first?.targetURL, "https://ci.example.com/1000/output")
                XCTAssertEqual(statuses.first?.context, "continuous-integration/jenkins")
                XCTAssertEqual(statuses.first?.creator?.login, "octocat")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListCommitStatusesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/statuses",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "statuses",
                                            statusCode: 200)

        let statuses = try await Octokit(session: session).listCommitStatuses(owner: "octocat", repository: "Hello-World", ref: "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(statuses.count, 1)
        XCTAssertEqual(statuses.first?.id, 1)
        XCTAssertEqual(statuses.first?.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(statuses.first?.avatarURL, "https://github.com/images/error/hubot_happy.gif")
        XCTAssertEqual(statuses.first?.nodeId, "MDY6U3RhdHVzMQ==")
        XCTAssertEqual(statuses.first?.state, Status.State.success)
        XCTAssertEqual(statuses.first?.description, "Build has completed successfully")
        XCTAssertEqual(statuses.first?.targetURL, "https://ci.example.com/1000/output")
        XCTAssertEqual(statuses.first?.context, "continuous-integration/jenkins")
        XCTAssertEqual(statuses.first?.creator?.login, "octocat")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
