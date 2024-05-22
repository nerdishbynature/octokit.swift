import OctoKit
import XCTest

class MilestoneTests: XCTestCase {
    func testGetMilestone() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/milestones/1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "milestone",
                                            statusCode: 200)

        let task = Octokit(session: session).milestone(owner: "octocat",
                                                       repo: "Hello-World",
                                                       number: 1) { response in
            switch response {
            case let .success(milestone):
                XCTAssertEqual(milestone.id, 1002604)
                XCTAssertEqual(milestone.number, 1)
                XCTAssertEqual(milestone.title, "v1.0")
                XCTAssertEqual(milestone.url?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/milestones/1")
                XCTAssertEqual(milestone.state, .open)
                XCTAssertEqual(milestone.milestoneDescription, "Tracking milestone for version 1.0")
                XCTAssertEqual(milestone.openIssues, 4)
                XCTAssertEqual(milestone.closedIssues, 8)
                XCTAssertEqual(milestone.creator?.login, "octocat")
                XCTAssertEqual(milestone.creator?.id, 1)
                XCTAssertEqual(milestone.creator?.type, "User")
                XCTAssertEqual(milestone.dueOn, Date(timeIntervalSince1970: 1349825941))

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetMilestones() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/milestones?direction=desc&page=10&per_page=2&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "milestones",
                                            statusCode: 200)

        let task = Octokit(session: session).milestones(owner: "octocat",
                                                        repo: "Hello-World",
                                                        sort: .created,
                                                        direction: .desc,
                                                        page: 2,
                                                        perPage: 10) { response in
            switch response {
            case let .success(milestone):
                XCTAssertEqual(milestone.count, 1)
                let milestone = milestone.first!
                XCTAssertEqual(milestone.id, 1002604)
                XCTAssertEqual(milestone.number, 1)
                XCTAssertEqual(milestone.title, "v1.0")
                XCTAssertEqual(milestone.url?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/milestones/1")
                XCTAssertEqual(milestone.state, .open)
                XCTAssertEqual(milestone.milestoneDescription, "Tracking milestone for version 1.0")
                XCTAssertEqual(milestone.openIssues, 4)
                XCTAssertEqual(milestone.closedIssues, 8)
                XCTAssertEqual(milestone.creator?.login, "octocat")
                XCTAssertEqual(milestone.creator?.id, 1)
                XCTAssertEqual(milestone.creator?.type, "User")
                XCTAssertEqual(milestone.dueOn, Date(timeIntervalSince1970: 1349825941))

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testCreateMilestone() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/milestones",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "milestone",
                                            statusCode: 200)

        let task = Octokit(session: session).createMilestone(owner: "octocat",
                                                             repo: "Hello-World",
                                                             title: "v1.0",
                                                             description: "Description",
                                                             dueDate: .now) { response in
            switch response {
            case let .success(milestone):
                XCTAssertEqual(milestone.id, 1002604)
                XCTAssertEqual(milestone.number, 1)
                XCTAssertEqual(milestone.title, "v1.0")
                XCTAssertEqual(milestone.url?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/milestones/1")
                XCTAssertEqual(milestone.state, .open)
                XCTAssertEqual(milestone.milestoneDescription, "Tracking milestone for version 1.0")
                XCTAssertEqual(milestone.openIssues, 4)
                XCTAssertEqual(milestone.closedIssues, 8)
                XCTAssertEqual(milestone.creator?.login, "octocat")
                XCTAssertEqual(milestone.creator?.id, 1)
                XCTAssertEqual(milestone.creator?.type, "User")
                XCTAssertEqual(milestone.dueOn, Date(timeIntervalSince1970: 1349825941))

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testUpdateMilestone() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/milestones/1",
                                            expectedHTTPMethod: "PATCH",
                                            jsonFile: "milestone",
                                            statusCode: 200)

        let task = Octokit(session: session).updateMilestone(owner: "octocat",
                                                             repo: "Hello-World",
                                                             number: 1) { response in
            switch response {
            case let .success(milestone):
                XCTAssertEqual(milestone.id, 1002604)
                XCTAssertEqual(milestone.number, 1)
                XCTAssertEqual(milestone.title, "v1.0")
                XCTAssertEqual(milestone.url?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/milestones/1")
                XCTAssertEqual(milestone.state, .open)
                XCTAssertEqual(milestone.milestoneDescription, "Tracking milestone for version 1.0")
                XCTAssertEqual(milestone.openIssues, 4)
                XCTAssertEqual(milestone.closedIssues, 8)
                XCTAssertEqual(milestone.creator?.login, "octocat")
                XCTAssertEqual(milestone.creator?.id, 1)
                XCTAssertEqual(milestone.creator?.type, "User")
                XCTAssertEqual(milestone.dueOn, Date(timeIntervalSince1970: 1349825941))

            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testDeletMilestone() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/milestones/1",
                                            expectedHTTPMethod: "DELETE",
                                            jsonFile: "milestone",
                                            statusCode: 200)

        let task = Octokit(session: session).deleteMilestone(owner: "octocat",
                                                             repo: "Hello-World",
                                                             number: 1) { response in
            if let error = response {
                XCTFail(error.localizedDescription)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
