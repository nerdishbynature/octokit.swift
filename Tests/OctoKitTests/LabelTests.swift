import XCTest
import OctoKit

class LabelTests: XCTestCase {
    static var allTests = [
        ("testGetLabel", testGetLabel),
        ("testGetLabelEncodesSpaceCorrectly", testGetLabelEncodesSpaceCorrectly),
        ("testGetLabels", testGetLabels),
        ("testGetLabelsSetsPagination", testGetLabelsSetsPagination),
        ("testCreateLabel", testCreateLabel),
        ("testParsingLabel", testParsingLabel),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]

    // MARK: Request Tests
    func testGetLabel() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/bug", expectedHTTPMethod: "GET", jsonFile: "label", statusCode: 200)
        let task = Octokit().label(session, owner: "octocat", repository: "hello-world", name: "bug") { response in
            switch response {
            case .success(let label):
                XCTAssertEqual(label.name, "bug")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetLabelEncodesSpaceCorrectly() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/help%20wanted", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let task = Octokit().label(session, owner: "octocat", repository: "hello-world", name: "help wanted") { response in
            switch response {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetLabels() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "labels", statusCode: 200)
        let task = Octokit().labels(session, owner: "octocat", repository: "hello-world") { response in
            switch response {
            case .success(let labels):
                XCTAssertEqual(labels.count, 7)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetLabelsSetsPagination() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=2&per_page=50", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let task = Octokit().labels(session, owner: "octocat", repository: "hello-world", page: "2", perPage: "50") { response in
            switch response {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testCreateLabel() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels", expectedHTTPMethod: "POST", jsonFile: "label", statusCode: 200)
        let task = Octokit().postLabel(session, owner: "octocat", repository: "hello-world", name: "test label", color: "ffffff") { response in
            switch response {
            case .success(let label):
                XCTAssertNotNil(label)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    
    // MARK: Parsing Tests
    func testParsingLabel() {
        let label = Helper.codableFromFile("label", type: Label.self)
        XCTAssertEqual(label.name, "bug")
        XCTAssertEqual(label.color, "fc2929")
        XCTAssertEqual(label.url, URL(string: "https://api.github.com/repos/octocat/hello-worId/labels/bug")!)
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
