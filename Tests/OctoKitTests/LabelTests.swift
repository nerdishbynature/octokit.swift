import OctoKit
import XCTest

class LabelTests: XCTestCase {
    // MARK: Request Tests

    func testGetLabel() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/bug", expectedHTTPMethod: "GET", jsonFile: "label", statusCode: 200)
        let task = Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "bug") { response in
            switch response {
            case let .success(label):
                XCTAssertEqual(label.name, "bug")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetLabelAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/bug", expectedHTTPMethod: "GET", jsonFile: "label", statusCode: 200)
        let label = try await Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "bug")
        XCTAssertEqual(label.name, "bug")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetLabelEncodesSpaceCorrectly() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/help%20wanted", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let task = Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "help wanted") { response in
            switch response {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetLabels() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "labels", statusCode: 200)
        let task = Octokit(session: session).labels(owner: "octocat", repository: "hello-world") { response in
            switch response {
            case let .success(labels):
                XCTAssertEqual(labels.count, 7)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetLabelsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "labels",
                                            statusCode: 200)
        let labels = try await Octokit(session: session).labels(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(labels.count, 7)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetLabelsSetsPagination() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=2&per_page=50", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let task = Octokit(session: session).labels(owner: "octocat", repository: "hello-world", page: "2", perPage: "50") { response in
            switch response {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testCreateLabel() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels", expectedHTTPMethod: "POST", jsonFile: "label", statusCode: 200)
        let task = Octokit(session: session).postLabel(owner: "octocat", repository: "hello-world", name: "test label", color: "ffffff") { response in
            switch response {
            case let .success(label):
                XCTAssertNotNil(label)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testCreateLabelAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels", expectedHTTPMethod: "POST", jsonFile: "label", statusCode: 200)
        let label = try await Octokit(session: session).postLabel(owner: "octocat", repository: "hello-world", name: "test label", color: "ffffff")
        XCTAssertNotNil(label)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Parsing Tests

    func testParsingLabel() {
        let label = Helper.codableFromFile("label", type: Label.self)
        XCTAssertEqual(label.name, "bug")
        XCTAssertEqual(label.color, "fc2929")
        XCTAssertEqual(label.url, URL(string: "https://api.github.com/repos/octocat/hello-worId/labels/bug")!)
    }
}
