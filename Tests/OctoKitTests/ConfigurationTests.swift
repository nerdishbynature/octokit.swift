import Foundation
import OctoKit
import XCTest

class ConfigurationTests: XCTestCase {
    func testTokenConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken, "12345".data(using: .utf8)?.base64EncodedString())
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
        XCTAssertTrue(subject.customHeaders?.isEmpty ?? true)
    }

    func testTokenConfigurationWithPreviewHeaders() {
        let subject = TokenConfiguration("12345", previewHeaders: [.reactions])
        XCTAssertEqual(subject.accessToken, "12345".data(using: .utf8)?.base64EncodedString())
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
        XCTAssertNotNil(subject.customHeaders)
        XCTAssertTrue(subject.customHeaders!.contains { $0.headerField == "Accept" && $0.value == "application/vnd.github.squirrel-girl-preview" })
    }

    func testEnterpriseTokenConfiguration() {
        let subject = TokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken, "12345".data(using: .utf8)?.base64EncodedString())
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

    func testAccessTokenFromResponse() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let expectation = "017ec60f4a182"
        XCTAssertEqual(config.accessTokenFromResponse(response), expectation)
    }

    func testHandleOpenURL() {
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let session = OctoKitURLTestSession(expectedURL: "https://github.com/login/oauth/access_token", expectedHTTPMethod: "POST", response: response, statusCode: 200)
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"], session: session)
        let url = URL(string: "urlscheme://authorize?code=dhfjgh23493&state=")!
        var token: String?
        config.handleOpenURL(url: url) { accessToken in
            token = accessToken.accessToken
        }
        XCTAssertEqual(token, "017ec60f4a182".data(using: .utf8)?.base64EncodedString())
        XCTAssertTrue(session.wasCalled)
    }
}
