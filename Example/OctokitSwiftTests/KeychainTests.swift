import XCTest
import Octokit

class KeychainTests: XCTestCase {
    func testKeychain() {
        let token = "accessToken"
        XCTAssert(Keychain.save(token), "Save should succeed")
        let retrieved = Keychain.load()
        XCTAssert(retrieved == token, "\(retrieved) should equal \(token)")
    }
}