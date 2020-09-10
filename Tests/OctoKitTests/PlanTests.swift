import XCTest
import OctoKit

class PlanTests: XCTestCase {
    static var allTests = [
        ("testPlanParsingFullPlan", testPlanParsingFullPlan),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    // MARK: Model Tests

    func testPlanParsingFullPlan() {
        let subject = Helper.codableFromFile("plan", type: Plan.self)
        XCTAssertEqual(subject.name, "micro")
        XCTAssertEqual(subject.space, 614400)
        XCTAssertEqual(subject.numberOfCollaborators, 0)
        XCTAssertEqual(subject.numberOfPrivateRepos, 5)
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
