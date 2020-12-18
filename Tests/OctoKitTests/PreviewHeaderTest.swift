import OctoKit
import XCTest

class PreviewHeaderTests: XCTestCase {
    static var allTests = [
        ("testReactionsPreview", testReactionsPreview),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    func testReactionsPreview() {
        let sut = PreviewHeader.reactions
        XCTAssertEqual(sut.header.headerField, "Accept")
        XCTAssertEqual(sut.header.value, "application/vnd.github.squirrel-girl-preview")
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
