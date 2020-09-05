import XCTest
import OctoKit

class UserTests: XCTestCase {
    static var allTests = [
        ("testGetUser", testGetUser),
        ("testFailingToGetUser", testFailingToGetUser),
        ("testGettingAuthenticatedUser", testGettingAuthenticatedUser),
        ("testFailToGetAuthenticatedUser", testFailToGetAuthenticatedUser),
        ("testUserParsingFullUser", testUserParsingFullUser),
        ("testUserParsingMinimalUser", testUserParsingMinimalUser),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    // MARK: Actual Request tests

    func testGetUser() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/mietzmithut", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let username = "mietzmithut"
        let task = Octokit().user(session, name: username) { response in
            switch response {
            case .success(let user):
                XCTAssertEqual(user.login, username)
            case .failure:
                XCTAssert(false, "should not get an user")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailingToGetUser() {
        let username = "notexisting"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/notexisting", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit().user(session, name: username) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve user")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGettingAuthenticatedUser() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_me", statusCode: 200)
        let task = Octokit(config).me(session) { response in
            switch response {
            case .success(let user):
                XCTAssertEqual(user.login, "pietbrauer")
            case .failure(let error):
                XCTAssert(false, "should not retrieve an error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetAuthenticatedUser() {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        let task = Octokit().me(session) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve user")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testUserParsingFullUser() {
        let subject = Helper.codableFromFile("user_me", type: User.self)
        XCTAssertEqual(subject.login, "pietbrauer")
        XCTAssertEqual(subject.id, 759730)
        XCTAssertEqual(subject.avatarURL, "https://avatars.githubusercontent.com/u/759730?v=3")
        XCTAssertEqual(subject.gravatarID, "")
        XCTAssertEqual(subject.type, "User")
        XCTAssertEqual(subject.name, "Piet Brauer")
        XCTAssertEqual(subject.company, "XING AG")
        XCTAssertEqual(subject.blog, "xing.to/PietBrauer")
        XCTAssertEqual(subject.location, "Hamburg")
        XCTAssertNil(subject.email)
        XCTAssertEqual(subject.numberOfPublicRepos, 6)
        XCTAssertEqual(subject.numberOfPublicGists, 10)
        XCTAssertEqual(subject.numberOfPrivateRepos, 4)
        XCTAssertNil(subject.nodeId)
        XCTAssertEqual(subject.htmlURL, "https://github.com/pietbrauer")
        XCTAssertEqual(subject.followersURL, "https://api.github.com/users/pietbrauer/followers")
        XCTAssertEqual(subject.followingURL, "https://api.github.com/users/pietbrauer/following{/other_user}")
        XCTAssertEqual(subject.gistsURL, "https://api.github.com/users/pietbrauer/gists{/gist_id}")
        XCTAssertEqual(subject.starredURL, "https://api.github.com/users/pietbrauer/starred{/owner}{/repo}")
        XCTAssertEqual(subject.subscriptionsURL, "https://api.github.com/users/pietbrauer/subscriptions")
        XCTAssertEqual(subject.reposURL, "https://api.github.com/users/pietbrauer/repos")
        XCTAssertEqual(subject.eventsURL, "https://api.github.com/users/pietbrauer/events{/privacy}")
        XCTAssertEqual(subject.receivedEventsURL, "https://api.github.com/users/pietbrauer/received_events")
        XCTAssertFalse(subject.siteAdmin!)
        XCTAssertTrue(subject.hireable!)
        XCTAssertNil(subject.bio)
        XCTAssertNil(subject.twitterUsername)
        XCTAssertEqual(subject.numberOfFollowers, 41)
        XCTAssertEqual(subject.numberOfFollowing, 19)
        XCTAssertEqual(subject.createdAt?.timeIntervalSince1970, 1304110716.0)
        XCTAssertEqual(subject.updatedAt?.timeIntervalSince1970, 1421091743.0)
        XCTAssertEqual(subject.numberOfPrivateGists, 7)
        XCTAssertEqual(subject.numberOfOwnPrivateRepos, 4)
        XCTAssertEqual(subject.amountDiskUsage, 49064)
        XCTAssertEqual(subject.numberOfCollaborators, 2)
        XCTAssertNil(subject.twoFactorAuthenticationEnabled)
        XCTAssertEqual(subject.subscriptionPlan?.name, "micro")
    }

    func testUserParsingMinimalUser() {
        let subject = Helper.codableFromFile("user_mietzmithut", type: User.self)
        XCTAssertEqual(subject.login, "mietzmithut")
        XCTAssertEqual(subject.id, 4672699)
        XCTAssertEqual(subject.avatarURL, "https://avatars.githubusercontent.com/u/4672699?v=3")
        XCTAssertEqual(subject.gravatarID, "")
        XCTAssertEqual(subject.type, "User")
        XCTAssertEqual(subject.name, "Julia Kallenberg")
        XCTAssertEqual(subject.company, "")
        XCTAssertEqual(subject.blog, "")
        XCTAssertEqual(subject.location, "Hamburg")
        XCTAssertEqual(subject.email, "")
        XCTAssertEqual(subject.numberOfPublicRepos, 7)
        XCTAssertEqual(subject.numberOfPublicGists, 0)
        XCTAssertNil(subject.numberOfPrivateRepos)
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
