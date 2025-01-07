import OctoKit
import XCTest

class UserTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetUserByName() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/mietzmithut", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let username = "mietzmithut"
        let task = Octokit(session: session).user(name: username) { response in
            switch response {
            case let .success(user):
                XCTAssertEqual(user.login, username)
                XCTAssertNotNil(user.createdAt)
            case .failure:
                XCTFail("should get a user")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailingToGetUserByName() {
        let username = "notexisting"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/notexisting", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(session: session).user(name: username) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve user")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetUserByNameAsync() async throws {
        let expectedUserId = 4672699
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/\(expectedUserId)", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let user = try await Octokit(session: session).user(id: expectedUserId)
        XCTAssertEqual(user.id, expectedUserId)
        XCTAssertNotNil(user.createdAt)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetUserById() {
        let expectedUserId = 4672699
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/\(expectedUserId)", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let task = Octokit(session: session).user(id: expectedUserId) { response in
            switch response {
            case let .success(user):
                XCTAssertEqual(user.id, expectedUserId)
                XCTAssertNotNil(user.createdAt)
            case .failure:
                XCTFail("should get a user")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailingToGetUserById() {
        let userId = 123456
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/\(userId)", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let task = Octokit(session: session).user(id: userId) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve user")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetUserByIdAsync() async throws {
        let expectedUserId = 4672699
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/\(expectedUserId)", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let user = try await Octokit(session: session).user(id: expectedUserId)
        XCTAssertEqual(user.id, expectedUserId)
        XCTAssertNotNil(user.createdAt)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGettingAuthenticatedUser() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_me", statusCode: 200)
        let task = Octokit(config, session: session).me { response in
            switch response {
            case let .success(user):
                XCTAssertEqual(user.login, "pietbrauer")
            case let .failure(error):
                XCTFail("should not retrieve an error \(error)")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetAuthenticatedUser() {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", response: json, statusCode: 401)
        let task = Octokit(session: session).me { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve user")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGettingAuthenticatedUserAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_me", statusCode: 200)
        let user = try await Octokit(config, session: session).me()
        XCTAssertEqual(user.login, "pietbrauer")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Model Tests

    func testUserParsingFullUser() {
        let subject = Helper.codableFromFile("user_me", type: User.self)
        XCTAssertEqual(subject.login, "pietbrauer")
        XCTAssertEqual(subject.id, 759_730)
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
        XCTAssertEqual(subject.nodeID, "MDQ6VXNlcjE=")
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
        XCTAssertEqual(subject.bio, "Tweeting about iOS and Drumming")
        XCTAssertEqual(subject.twitterUsername, "pietbrauer")
        XCTAssertEqual(subject.numberOfFollowers, 41)
        XCTAssertEqual(subject.numberOfFollowing, 19)
        XCTAssertEqual(subject.createdAt?.timeIntervalSince1970, 1_304_110_716.0)
        XCTAssertEqual(subject.updatedAt?.timeIntervalSince1970, 1_421_091_743.0)
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
        XCTAssertEqual(subject.id, 4_672_699)
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
}
