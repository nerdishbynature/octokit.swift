import XCTest
import Foundation
import OctoKit

class ConfigurationTests: XCTestCase {
    static var allTests = [
        ("testTokenConfiguration", testTokenConfiguration),
        ("testEnterpriseTokenConfiguration", testEnterpriseTokenConfiguration),
        ("testOAuthConfiguration", testOAuthConfiguration),
        ("testOAuthTokenConfiguration", testOAuthTokenConfiguration),
        ("testAccessTokenFromResponse", testAccessTokenFromResponse),
        ("testHandleOpenURL", testHandleOpenURL),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    func testTokenConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken, "12345")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testEnterpriseTokenConfiguration() {
        let subject = TokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken, "12345")
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
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let session = OctoKitURLTestSession(expectedURL: "https://github.com/login/oauth/access_token", expectedHTTPMethod: "POST", response: response, statusCode: 200)
        let url = URL(string: "urlscheme://authorize?code=dhfjgh23493&state=")!
        var token: String? = nil
        config.handleOpenURL(session, url: url) { accessToken in
            token = accessToken.accessToken
        }
        XCTAssertEqual(token, "017ec60f4a182")
        XCTAssertTrue(session.wasCalled)
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = thisClass.defaultTestSuite.tests.count
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
