
import Foundation
import OctoKit
import XCTest

class GistTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let task = Octokit(config, session: session).myGists { response in
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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetMyGistsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let gists = try await Octokit(config, session: session).myGists()
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetMyStarredGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/starred?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "starred_gists",
                                            statusCode: 200)
        let task = Octokit(config, session: session).myStarredGists { response in
            switch response {
            case let .success(gists):
                XCTAssertEqual(gists.count, 1)
                XCTAssertEqual(gists[0].description, "Hello World Starred Examples")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetMyStarredGistsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/starred?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "starred_gists",
                                            statusCode: 200)
        let gists = try await Octokit(config, session: session).myStarredGists()
        XCTAssertEqual(gists.count, 1)
        XCTAssertEqual(gists[0].description, "Hello World Starred Examples")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetGists() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let task = Octokit(config, session: session).gists(owner: "vincode-io") { response in
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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetGistsAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let gists = try await Octokit(config, session: session).gists(owner: "vincode-io")
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let task = Octokit(session: session).gist(id: "aa5a315d61ae9438b18d") { response in
            switch response {
            case let .success(gist):
                XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
                guard let forkID = gist.forkOf?.id else {
                    XCTFail("Didn't properly decode fork parent gist")
                    return
                }
                XCTAssertEqual(forkID, "f87cbd23c4bc9ad7b04a9f80cf532fc3")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit(session: session).gist(id: "aa5a315d61ae9438b18d")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testPostGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit(session: session).postGistFile(description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true) { response in
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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPostGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        do {
            let gist = try await Octokit(session: session).postGistFile(description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true)
            XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            XCTAssertTrue(session.wasCalled)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    #endif

    func testPatchGist() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let task = Octokit(session: session).patchGistFile(id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program") { response in
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

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPatchGistAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit(session: session).patchGistFile(id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
