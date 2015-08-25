import XCTest
import Foundation
import Octokit
import Nocilla

class ConfigurationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().clearStubs()
        LSNocilla.sharedInstance().stop()
    }

    func testTokenConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testEnterpriseTokenConfiguration() {
        let subject = TokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testOAuthConfiguration() {
        let subject = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testOAuthTokenConfiguration() {
        let subject = OAuthConfiguration(enterpriseURL, token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testAuthorizeURLRequest() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let request = OAuthRouter.Authorize(config).URLRequest
        let expected = NSURL(string: "https://github.com/login/oauth/authorize?client_id=12345&scope=repo,read%3Aorg")!
        XCTAssertEqual(request!.URL!, expected)
    }

    func testAccessTokenURLRequest() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let request = OAuthRouter.AccessToken(config, "dhfjgh23493").URLRequest
        let expected = NSURL(string: "https://github.com/login/oauth/access_token")!
        let expectedBody = "client_id=12345&client_secret=6789&code=dhfjgh23493"
        XCTAssertEqual(request!.URL!, expected)
        let string = NSString(data: request!.HTTPBody!, encoding: NSUTF8StringEncoding)!
        XCTAssertEqual(string as String, expectedBody)
    }

    func testAccessTokenFromResponse() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let expectation = "017ec60f4a182"
        XCTAssertEqual(config.accessTokenFromResponse(response)!, expectation)
    }

    func testHandleOpenURL() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        stubRequest("POST", "https://github.com/login/oauth/access_token").andReturn(200).withBody(response)
        let expectation = expectationWithDescription("access_token")
        let url = NSURL(string: "urlscheme://authorize?code=dhfjgh23493")!
        config.handleOpenURL(url) { token in
            XCTAssertEqual(token.accessToken!, "017ec60f4a182")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: { error in
            XCTAssertNil(error, "\(error)")
        })
    }
}
