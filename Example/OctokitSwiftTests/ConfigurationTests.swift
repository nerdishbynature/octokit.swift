import XCTest
import Octokit

class ConfigurationTests: XCTestCase {
    func testConfigurationBaseURL() {
        let subject = TokenConfiguration(token: "12345")
        XCTAssertEqual(subject.serverType, Server.Github)
        XCTAssertEqual(subject.accessToken!, "12345")
        XCTAssertEqual(subject.apiEndpoint, "https://api.github.com")
    }

    func testEnterpriseConfigurationBaseURL() {
        let subject = TokenConfiguration(enterpriseURL, token: "12345")
        XCTAssertEqual(subject.serverType, Server.Enterprise)
        XCTAssertEqual(subject.accessToken!, "12345")
    }
}
