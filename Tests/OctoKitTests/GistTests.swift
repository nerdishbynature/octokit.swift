
import Foundation
import OctoKit
import XCTest

class GistTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/gists?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "gists",
            statusCode: 200
        )
        let task = Octokit(config).myGists(session) { response in
            switch response {
            case let .success(gists):
                XCTAssertEqual(gists.count, 1)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetMyGistsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/gists?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "gists",
            statusCode: 200
        )
        let gists = try await Octokit(config).myGists(session)
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "gists",
            statusCode: 200
        )
        let task = Octokit(config).gists(session, owner: "vincode-io") { response in
            switch response {
            case let .success(gists):
                XCTAssertEqual(gists.count, 1)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetGistsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(
            expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
            expectedHTTPMethod: "GET",
            expectedHTTPHeaders: headers,
            jsonFile: "gists",
            statusCode: 200
        )
        let gists = try await Octokit(config).gists(session, owner: "vincode-io")
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let task = Octokit().gist(session, id: "aa5a315d61ae9438b18d") { response in
            switch response {
            case let .success(gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit().gist(session, id: "aa5a315d61ae9438b18d")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testPostGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit().postGistFile(session, description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true) { response in
            switch response {
            case let .success(gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPostGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        do {
            let gist = try await Octokit().postGistFile(session, description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true)
            XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            XCTAssertTrue(session.wasCalled)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    #endif

    func testPatchGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit().patchGistFile(session, id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program") { response in
            switch response {
            case let .success(gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if !canImport(FoundationNetworking)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPatchGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit().patchGistFile(session, id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
