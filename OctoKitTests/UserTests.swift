import XCTest
import OctoKit

class UserTests: XCTestCase {
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
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGettingAuthenticatedUser() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user?access_token=token", expectedHTTPMethod: "GET", jsonFile: "user_me", statusCode: 200)
        let task = Octokit(TokenConfiguration("token")).me(session) { response in
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
            case .failure:
                XCTAssertTrue(false)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testUserParsingFullUser() {
        let subject = User(Helper.JSONFromFile("user_me") as! [String: AnyObject])
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
    }

    func testUserParsingMinimalUser() {
        let subject = User(Helper.JSONFromFile("user_mietzmithut") as! [String: AnyObject])
        XCTAssertEqual(subject.login!, "mietzmithut")
        XCTAssertEqual(subject.id, 4672699)
        XCTAssertEqual(subject.avatarURL!, "https://avatars.githubusercontent.com/u/4672699?v=3")
        XCTAssertEqual(subject.gravatarID!, "")
        XCTAssertEqual(subject.type!, "User")
        XCTAssertEqual(subject.name!, "Julia Kallenberg")
        XCTAssertEqual(subject.company!, "")
        XCTAssertEqual(subject.blog!, "")
        XCTAssertEqual(subject.location!, "Hamburg")
        XCTAssertEqual(subject.email!, "")
        XCTAssertEqual(subject.numberOfPublicRepos!, 7)
        XCTAssertEqual(subject.numberOfPublicGists!, 0)
        XCTAssertNil(subject.numberOfPrivateRepos)
    }
}
