import XCTest
import OctoKit



class NotificationTests: XCTestCase {
    static var allTests = [
        ("testgetMyNotifications", testgetMyNotifications),
        ("testmarkNotificationsRead",testmarkNotifcationsRead),
        ("testGetNotificationThread",testGetNotificationThread),
        ("testGetThreadSubscription",testGetThreadSubscription),
        ("testSetThreadSubscription",testSetThreadSubscription),
        ("testDeleteThreadSubscription",testDeleteThreadSubscription),
        ("testListRepositoryNotifications",testListRepositoryNotifications),
        ("testMarkRepositoryNofificationsRead",testMarkRepositoryNofificationsRead),
    ]
    
    
    // MARK: Actual Request tests
    
    func testgetMyNotifications() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?all=false&page=1&participating=false&per_page=100", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "notification_threads", statusCode: 200)
        let task = Octokit(config).myNotifications(session,all: false,participating: false, page: "1",perPage: "100"){ response in
            switch response {
                case .success(let notifications):
                    XCTAssertEqual(notifications.count,1)
                    XCTAssertEqual(notifications.first?.id, "1")
                case .failure(let error):
                    XCTAssertNil(error)
            }
            
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testmarkNotifcationsRead() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?last_read_at=last_read_at&read=false", expectedHTTPMethod: "PUT", expectedHTTPHeaders: headers, response: "", statusCode: 200)
        let task = Octokit(config).markNotificationsRead(session){ response in
            XCTAssertNil(response)
            
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    
    func testGetNotificationThread(){
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "notification_thread", statusCode: 200)
        let task = Octokit(config).getNotificationThread(session,threadId: "1") { response in
            switch response {
                case .success(let notification):
                    XCTAssertEqual(notification.id, "1")
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    
    func testGetThreadSubscription(){
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "notification_thread_subscription", statusCode: 200)
        let task = Octokit(config).getThreadSubscription(session,threadId: "1") { response in
            switch response {
                case .success(let notification):
                    XCTAssertEqual(notification.id, 1)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    
    func testSetThreadSubscription(){
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription", expectedHTTPMethod: "PUT", expectedHTTPHeaders: headers, jsonFile: "notification_thread_subscription", statusCode: 200)
        let task = Octokit(config).setThreadSubscription(session,threadId: "1") { response in
            switch response {
                case .success(let notification):
                    XCTAssertEqual(notification.id, 1)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testDeleteThreadSubscription(){
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription", expectedHTTPMethod: "DELETE", expectedHTTPHeaders: headers, response: "", statusCode: 200)
        let task = Octokit(config).deleteThreadSubscription(session,threadId: "1") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    
    func testListRepositoryNotifications(){
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications?all=false&page=1&participating=false&perPage=100", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "notification_threads", statusCode: 200)
        let task = Octokit(config).listRepositoryNotifications(session,owner: "octocat",repository: "hello-world") { response in
            switch response {
                case .success(let notifications):
                    XCTAssertEqual(notifications.count,1)
                    XCTAssertEqual(notifications.first?.id, "1")
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testMarkRepositoryNofificationsRead() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications", expectedHTTPMethod: "PUT", expectedHTTPHeaders: headers, response: "", statusCode: 200)
        let task = Octokit(config).markRepositoryNotificationsRead(session,owner: "octocat",repository: "hello-world") { response in
            XCTAssertNil(response)
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}


