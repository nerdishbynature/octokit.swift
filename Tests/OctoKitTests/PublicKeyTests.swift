import XCTest
import RequestKit
import OctoKit

class PublicKeyTests: XCTestCase {
    static var allTests = [
        ("testPostPublicKey", testPostPublicKey),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    // MARK: Actual Request tests

    func testPostPublicKey() {
        let config = TokenConfiguration("12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/keys?access_token=12345", expectedHTTPMethod: "POST", jsonFile: "public_key", statusCode: 201)
        let task = Octokit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .success(let publicKey):
                XCTAssertEqual(publicKey, "test-key")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        #if os(iOS)
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #else
        let darwinCount = thisClass.defaultTestSuite().tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
