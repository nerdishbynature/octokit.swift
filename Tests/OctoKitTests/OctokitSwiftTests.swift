import OctoKit
import XCTest

let enterpriseURL = "https://enterprise.myserver.com"

class OctokitSwiftTests: XCTestCase {
    static var allTests = [
        ("testOctokitInitializerWithEmptyConfig", testOctokitInitializerWithEmptyConfig),
        ("testOctokitInitializerWithConfig", testOctokitInitializerWithConfig),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://api.github.com")
    }

    func testOctokitInitializerWithConfig() {
        let config = TokenConfiguration("12345", url: enterpriseURL)
        let subject = Octokit(config)
        XCTAssertEqual(subject.configuration.apiEndpoint, "https://enterprise.myserver.com")
    }

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if os(iOS)
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #else
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
