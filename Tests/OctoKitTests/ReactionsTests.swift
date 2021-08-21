import OctoKit
import XCTest

class ReactionsTests: XCTestCase {
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
}
