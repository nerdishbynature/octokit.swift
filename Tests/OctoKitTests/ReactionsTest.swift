import OctoKit
import XCTest

class ReactionsTests: XCTestCase {
    static var allTests = [
        ("testFullResponse", testFullResponse),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    // MARK: Model Tests

    func testFullResponse() {
        let subject = Helper.codableFromFile("reactions", type: Reactions.self)
        XCTAssertEqual(subject.totalCount, 13)
        XCTAssertEqual(subject.thumbsUp, 3)
        XCTAssertEqual(subject.thumbsDown, 1)
        XCTAssertEqual(subject.laugh, 0)
        XCTAssertEqual(subject.confused, 0)
        XCTAssertEqual(subject.heart, 1)
        XCTAssertEqual(subject.hooray, 0)
        XCTAssertEqual(subject.rocket, 6)
        XCTAssertEqual(subject.eyes, 2)
        XCTAssertEqual(subject.url, "https://api.github.com/repos/octocat/Hello-World/issues/1347/reactions")
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
