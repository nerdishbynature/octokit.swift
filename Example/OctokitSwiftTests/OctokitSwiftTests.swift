import XCTest
import Octokit

let enterpriseURL = "https://enterprise.myserver.com"

class OctokitSwiftTests: XCTestCase {
    func testConfigurationBaseURL() {
        let subject = Configuration()
        XCTAssert(subject.serverType == .Github, "Should default to public Github")
    }

    func testEnterpriseConfigurationBaseURL() {
        let subject = Configuration(enterpriseURL)
        XCTAssert(subject.serverType == .Enterprise, "Should use enterprise")
    }

    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssert(subject.baseURL == "https://api.github.com", "Should default to public Github")
    }

    func testOctokitInitializerWithConfig() {
        let config = Configuration(enterpriseURL)
        let subject = Octokit(config)
        XCTAssert(subject.baseURL == "https://enterprise.myserver.com", "Should use enterprise Github")
    }
}