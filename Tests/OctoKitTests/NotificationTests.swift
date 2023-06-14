import OctoKit
import XCTest

class NotificationTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyNotifications() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?all=false&page=1&participating=false&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let task = Octokit(config, session: session).myNotifications(all: false, participating: false, page: "1", perPage: "100") { response in
            switch response {
            case let .success(notifications):
                XCTAssertEqual(notifications.count, 1)
                XCTAssertEqual(notifications.first?.id, "1")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testMarkNotifcationsRead() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?last_read_at=last_read_at&read=false",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        let task = Octokit(config, session: session).markNotificationsRead { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetNotificationThread() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread",
                                            statusCode: 200)
        let task = Octokit(config, session: session).getNotificationThread(threadId: "1") { response in
            switch response {
            case let .success(notification):
                XCTAssertEqual(notification.id, "1")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetThreadSubscription() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let task = Octokit(config, session: session).getThreadSubscription(threadId: "1") { response in
            switch response {
            case let .success(notification):
                XCTAssertEqual(notification.id, 1)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testSetThreadSubscription() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let task = Octokit(config, session: session).setThreadSubscription(threadId: "1") { response in
            switch response {
            case let .success(notification):
                XCTAssertEqual(notification.id, 1)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testDeleteThreadSubscription() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "DELETE",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        let task = Octokit(config, session: session).deleteThreadSubscription(threadId: "1") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testListRepositoryNotifications() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications?all=false&page=1&participating=false&perPage=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let task = Octokit(config, session: session).listRepositoryNotifications(owner: "octocat", repository: "hello-world") { response in
            switch response {
            case let .success(notifications):
                XCTAssertEqual(notifications.count, 1)
                XCTAssertEqual(notifications.first?.id, "1")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testMarkRepositoryNofificationsRead() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        let task = Octokit(config, session: session).markRepositoryNotificationsRead(owner: "octocat", repository: "hello-world") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
