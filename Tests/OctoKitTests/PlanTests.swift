import OctoKit
import XCTest

class PlanTests: XCTestCase {
    // MARK: Model Tests

    func testPlanParsingFullPlan() {
        let subject = Helper.codableFromFile("plan", type: Plan.self)
        XCTAssertEqual(subject.name, "micro")
        XCTAssertEqual(subject.space, 614_400)
        XCTAssertEqual(subject.numberOfCollaborators, 0)
        XCTAssertEqual(subject.numberOfPrivateRepos, 5)
    }
}
