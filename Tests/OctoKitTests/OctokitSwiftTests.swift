import XCTest
import OctoKit

let enterpriseURL = "https://enterprise.myserver.com"

class OctokitSwiftTests: XCTestCase {
    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://api.github.com")
    }

    func testOctokitInitializerWithConfig() {
        let config = TokenConfiguration("12345", url: enterpriseURL)
        let subject = Octokit(config)
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://enterprise.myserver.com")
    }
}
