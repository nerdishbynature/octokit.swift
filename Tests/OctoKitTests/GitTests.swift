import OctoKit
import XCTest

class GitTests: XCTestCase {
    // MARK: Tree

    func testGetTree() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/trees/034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let task = Octokit(session: session).tree(owner: "octocat",
                                                   repository: "Hello-World",
                                                   treeSHA: "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f") { response in
            switch response {
            case let .success(tree):
                XCTAssertEqual(tree.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
                XCTAssertEqual(tree.tree.count, 1)
                XCTAssertEqual(tree.tree.first?.path, "README.md")
                XCTAssertEqual(tree.tree.first?.type, "blob")
                XCTAssertFalse(tree.isTruncated)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetTreeRecursive() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/trees/034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f?recursive=1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let task = Octokit(session: session).tree(owner: "octocat",
                                                   repository: "Hello-World",
                                                   treeSHA: "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f",
                                                   recursive: true) { response in
            switch response {
            case let .success(tree):
                XCTAssertEqual(tree.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetTreeAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/trees/034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let tree = try await Octokit(session: session).tree(owner: "octocat",
                                                            repository: "Hello-World",
                                                            treeSHA: "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
        XCTAssertEqual(tree.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
        XCTAssertEqual(tree.tree.count, 1)
        XCTAssertEqual(tree.tree.first?.path, "README.md")
        XCTAssertFalse(tree.isTruncated)
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetTreeRecursiveAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/trees/034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f?recursive=1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let tree = try await Octokit(session: session).tree(owner: "octocat",
                                                            repository: "Hello-World",
                                                            treeSHA: "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f",
                                                            recursive: true)
        XCTAssertEqual(tree.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Refs

    func testListRefs() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/refs",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let task = Octokit(session: session).listRefs(owner: "octocat", repository: "Hello-World") { response in
            switch response {
            case let .success(refs):
                XCTAssertEqual(refs.count, 1)
                XCTAssertEqual(refs.first?.ref, "refs/heads/main")
                XCTAssertEqual(refs.first?.object.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
                XCTAssertEqual(refs.first?.object.type, "commit")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testListRefsFiltered() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/refs/heads",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let task = Octokit(session: session).listRefs(owner: "octocat", repository: "Hello-World", ref: "heads") { response in
            switch response {
            case let .success(refs):
                XCTAssertEqual(refs.count, 1)
                XCTAssertEqual(refs.first?.ref, "refs/heads/main")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListRefsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/refs",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let refs = try await Octokit(session: session).listRefs(owner: "octocat", repository: "Hello-World")
        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs.first?.ref, "refs/heads/main")
        XCTAssertEqual(refs.first?.object.sha, "034f8fb9a6a4fea547b1f15bc6c3eb3a6fa8c09f")
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListRefsFilteredAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/git/refs/heads",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let refs = try await Octokit(session: session).listRefs(owner: "octocat", repository: "Hello-World", ref: "heads")
        XCTAssertEqual(refs.count, 1)
        XCTAssertEqual(refs.first?.ref, "refs/heads/main")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
