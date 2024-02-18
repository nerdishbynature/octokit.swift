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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetMyNotificationsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?all=false&page=1&participating=false&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let notifications = try await Octokit(config, session: session).myNotifications(all: false, participating: false, page: "1", perPage: "100")
        XCTAssertEqual(notifications.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testMarkNotifcationsReadAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?last_read_at=last_read_at&read=false",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).markNotificationsRead()
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetNotificationThreadAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).getNotificationThread(threadId: "1")
        XCTAssertEqual(notification.id, "1")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetThreadSubscriptionAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).getThreadSubscription(threadId: "1")
        XCTAssertEqual(notification.id, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testSetThreadSubscriptionAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).setThreadSubscription(threadId: "1")
        XCTAssertEqual(notification.id, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testDeleteThreadSubscriptionAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "DELETE",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).deleteThreadSubscription(threadId: "1")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListRepositoryNotificationsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications?all=false&page=1&participating=false&perPage=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let notifications = try await Octokit(config, session: session).listRepositoryNotifications(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(notifications.count, 1)
        XCTAssertEqual(notifications.first?.id, "1")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testMarkRepositoryNofificationsReadAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).markRepositoryNotificationsRead(owner: "octocat", repository: "hello-world")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
