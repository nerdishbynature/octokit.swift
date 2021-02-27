import XCTest
import OctoKit

class PreviewHeaderTests: XCTestCase {
    func testReactionsPreview() {
        let sut = PreviewHeader.reactions
        XCTAssertEqual(sut.header.headerField, "Accept")
        XCTAssertEqual(sut.header.value, "application/vnd.github.squirrel-girl-preview")
    }
}
