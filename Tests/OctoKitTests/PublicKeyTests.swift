import XCTest
import RequestKit
import OctoKit

class PublicKeyTests: XCTestCase {
    // MARK: Actual Request tests

    func testPostPublicKey() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/keys", expectedHTTPMethod: "POST", expectedHTTPHeaders: headers, jsonFile: "public_key", statusCode: 201)
        let task = Octokit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .success(let publicKey):
                XCTAssertEqual(publicKey, "test-key")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
}
