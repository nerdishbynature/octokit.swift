import OctoKit
import XCTest

class GitTests: XCTestCase {
    // MARK: Tree

    func testGetTree() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/trees/f6453ef0e01c0dc276b3e76d71685e99ff98d66f",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let task = Octokit(session: session).tree(owner: "nerdishbynature",
                                                  repository: "octokit.swift",
                                                  treeSHA: "f6453ef0e01c0dc276b3e76d71685e99ff98d66f") { response in
            switch response {
            case let .success(tree):
                XCTAssertEqual(tree.sha, "f6453ef0e01c0dc276b3e76d71685e99ff98d66f")
                XCTAssertEqual(tree.tree.count, 13)
                XCTAssertEqual(tree.tree.first?.path, ".devcontainer")
                XCTAssertEqual(tree.tree.first?.type, "tree")
                XCTAssertFalse(tree.isTruncated)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetTreeRecursive() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/trees/f6453ef0e01c0dc276b3e76d71685e99ff98d66f?recursive=1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let task = Octokit(session: session).tree(owner: "nerdishbynature",
                                                  repository: "octokit.swift",
                                                  treeSHA: "f6453ef0e01c0dc276b3e76d71685e99ff98d66f",
                                                  recursive: true) { response in
            switch response {
            case let .success(tree):
                XCTAssertEqual(tree.sha, "f6453ef0e01c0dc276b3e76d71685e99ff98d66f")
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
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/trees/f6453ef0e01c0dc276b3e76d71685e99ff98d66f",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let tree = try await Octokit(session: session).tree(owner: "nerdishbynature",
                                                            repository: "octokit.swift",
                                                            treeSHA: "f6453ef0e01c0dc276b3e76d71685e99ff98d66f")
        XCTAssertEqual(tree.sha, "f6453ef0e01c0dc276b3e76d71685e99ff98d66f")
        XCTAssertEqual(tree.tree.count, 13)
        XCTAssertEqual(tree.tree.first?.path, ".devcontainer")
        XCTAssertFalse(tree.isTruncated)
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetTreeRecursiveAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/trees/f6453ef0e01c0dc276b3e76d71685e99ff98d66f?recursive=1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_tree",
                                            statusCode: 200)

        let tree = try await Octokit(session: session).tree(owner: "nerdishbynature",
                                                            repository: "octokit.swift",
                                                            treeSHA: "f6453ef0e01c0dc276b3e76d71685e99ff98d66f",
                                                            recursive: true)
        XCTAssertEqual(tree.sha, "f6453ef0e01c0dc276b3e76d71685e99ff98d66f")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Refs

    func testListRefs() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/refs",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let task = Octokit(session: session).listRefs(owner: "nerdishbynature", repository: "octokit.swift") { response in
            switch response {
            case let .success(refs):
                XCTAssertEqual(refs.first?.ref, "refs/heads/0.6.2-hotfix")
                XCTAssertEqual(refs.first?.object.sha, "310ac61fb2ae42b994286cc817015a351f03532d")
                XCTAssertEqual(refs.first?.object.type, "commit")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testListRefsFiltered() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/refs/heads",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let task = Octokit(session: session).listRefs(owner: "nerdishbynature", repository: "octokit.swift", ref: "heads") { response in
            switch response {
            case let .success(refs):
                XCTAssertEqual(refs.first?.ref, "refs/heads/0.6.2-hotfix")
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
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/refs",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let refs = try await Octokit(session: session).listRefs(owner: "nerdishbynature", repository: "octokit.swift")
        XCTAssertEqual(refs.first?.ref, "refs/heads/0.6.2-hotfix")
        XCTAssertEqual(refs.first?.object.sha, "310ac61fb2ae42b994286cc817015a351f03532d")
        XCTAssertTrue(session.wasCalled)
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListRefsFilteredAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/git/refs/heads",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "git_refs",
                                            statusCode: 200)

        let refs = try await Octokit(session: session).listRefs(owner: "nerdishbynature", repository: "octokit.swift", ref: "heads")
        XCTAssertEqual(refs.first?.ref, "refs/heads/0.6.2-hotfix")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
