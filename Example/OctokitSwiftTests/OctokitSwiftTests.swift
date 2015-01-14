import XCTest
import Octokit
import Nocilla

let enterpriseURL = "https://enterprise.myserver.com"

class OctokitSwiftTests: XCTestCase {
    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://api.github.com")
    }

    func testOctokitInitializerWithConfig() {
        let config = TokenConfiguration(enterpriseURL, token: "12345")
        let subject = Octokit(config)
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://enterprise.myserver.com")
    }
}