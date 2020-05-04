
import Foundation
import XCTest
import OctoKit

class GistTests: XCTestCase {

    static var allTests = [
        ("testGetMyGists", testGetGists),
        ("testGetGists", testGetGists),
        ("testGetGist", testGetGist),
        ("testPostGist", testPostGist),
        ("testPatchGist", testPatchGist),
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
    ]
    
    // MARK: Actual Request tests
    
    func testGetMyGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists?page=1&per_page=100", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "gists", statusCode: 200)
        let task = Octokit(config).myGists(session) { response in
            switch response {
            case .success(let gists):
                XCTAssertEqual(gists.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "gists", statusCode: 200)
        let task = Octokit(config).gists(session, owner: "vincode-io") { response in
            switch response {
            case .success(let gists):
                XCTAssertEqual(gists.count, 1)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testGetGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let task = Octokit().gist(session, id: "aa5a315d61ae9438b18d") { response in
            switch response {
            case .success(let gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testPostGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit().postGistFile(session, description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true) { response in
            switch response {
            case .success(let gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }
    
    func testPatchGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit().patchGistFile(session, id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program") { response in
            switch response {
            case .success(let gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
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
        let darwinCount = thisClass.defaultTestSuite.tests.count
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
