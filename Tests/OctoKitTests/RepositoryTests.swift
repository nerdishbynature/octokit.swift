import OctoKit
import XCTest

class RepositoryTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetRepositories() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let task = Octokit(session: session).repositories(owner: "octocat") { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoriesEnterprise() {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/users/octocat/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let task = Octokit(config, session: session).repositories(owner: "octocat") { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAuthenticatedRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let task = Octokit(config, session: session).repositories { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAuthenticatedRepositoriesEnterprise() {
        let config = TokenConfiguration("user:12345", url: "https://enterprise.nerdishbynature.com/api/v3/")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let task = Octokit(config, session: session).repositories { response in
            switch response {
            case let .success(repositories):
                XCTAssertEqual(repositories.count, 1)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepositories() {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            response: json,
                                            statusCode: 401)
        let task = Octokit(config, session: session).repositories { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 401)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoriesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(session: session).repositories(owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetRepository() {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let task = Octokit(session: session).repository(owner: owner, name: name) { response in
            switch response {
            case let .success(repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoryEnterprise() {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let task = Octokit(config, session: session).repository(owner: owner, name: name) { response in
            switch response {
            case let .success(repo):
                XCTAssertEqual(repo.name, name)
                XCTAssertEqual(repo.owner.login, owner)
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepository() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let (owner, name) = ("mietzmithut", "Test")
        let task = Octokit(session: session).repository(owner: owner, name: name) { response in
            switch response {
            case .success:
                XCTAssert(false, "should not retrieve repositories")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetRepositoryAsync() async throws {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let repo = try await Octokit(session: session).repository(owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testfailureRepositoryContent() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content",
                                            statusCode: 404)

        Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                    name: "octokit.swift",
                                                    path: "Package.swift",
                                                    ref: nil) { response in
            switch response {
            case .success:
                XCTFail("repositoryContent() call should have returned an error response.")
            case let .failure(error as NSError):
                XCTAssertEqual(error.code, 404)
                XCTAssertEqual(error.domain, OctoKitErrorDomain)
            }
        }
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testfailureRepositoryContentAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content",
                                            statusCode: 404)

        do {
            _ = try await Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                                      name: "octokit.swift",
                                                                      path: "Package.swift")
            XCTFail("repositoryContent function should have thrown an error")
        } catch {
            XCTAssertTrue(session.wasCalled)
        }
    }
    #endif

    func testRepositoryContentWithContentFileResponse() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content",
                                            statusCode: 200)

        Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                    name: "octokit.swift",
                                                    path: "Package.swift",
                                                    ref: nil) { response in
            switch response {
            case .success:
                break
            case .failure:
                XCTFail("repositoryContent() call should not have returned an error response.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testRepositoryContentAsyncWithContentFileResponse() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content",
                                            statusCode: 200)
        _ = try await Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                                  name: "octokit.swift",
                                                                  path: "Package.swift")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testRepositoryContentWithDirResponse() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "contents",
                                            statusCode: 200)
        Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                    name: "octokit.swift",
                                                    path: nil,
                                                    ref: nil) { response in
            switch response {
            case let .success(contentResponse):
                guard case .contentDirectory = contentResponse else {
                    XCTFail("ContentResponse enum should have returned contentDirectory case")
                    return
                }
            case .failure:
                XCTFail("repositoryContent() call should not have returned an error response.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testRepositoryContentAsyncWithDirResponse() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/nerdishbynature/octokit.swift/contents",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "contents",
                                            statusCode: 200)
        _ = try await Octokit(session: session).repositoryContent(owner: "nerdishbynature",
                                                                  name: "octokit.swift",
                                                                  path: nil,
                                                                  ref: nil)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testRepositoryContentWithSubmoduleResponse() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/muter-mutation-testing/muter/contents/homebrew-formulae?ref=master",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content_submodule",
                                            statusCode: 200)
        Octokit(session: session).repositoryContent(owner: "muter-mutation-testing",
                                                    name: "muter",
                                                    path: "homebrew-formulae",
                                                    ref: "master") { response in
            switch response {
            case .success:
                break
            case .failure:
                XCTFail("repositoryContent() call should not have returned an error response.")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testRepositoryContentAsyncWithSubmoduleResponse() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/muter-mutation-testing/muter/contents/homebrew-formulae?ref=master",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "content_submodule",
                                            statusCode: 200)
        _ = try await Octokit(session: session).repositoryContent(owner: "muter-mutation-testing",
                                                                  name: "muter",
                                                                  path: "homebrew-formulae",
                                                                  ref: "master")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    // MARK: Model Tests

    func testUserParsingFullRepository() throws {
        let subject = Helper.codableFromFile("repo", type: Repository.self)
        XCTAssertEqual(subject.owner.login, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4_672_699)

        XCTAssertEqual(subject.id, 10_824_973)
        XCTAssertEqual(subject.name, "Test")
        XCTAssertEqual(subject.fullName, "mietzmithut/Test")
        XCTAssertEqual(subject.isPrivate, false)
        XCTAssertEqual(subject.repositoryDescription, "")
        XCTAssertFalse(subject.isFork)
        XCTAssertEqual(subject.gitURL, "git://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.sshURL, "git@github.com:mietzmithut/Test.git")
        XCTAssertEqual(subject.cloneURL, "https://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.size, 132)
        XCTAssertTrue(try XCTUnwrap(subject.hasWiki))
        XCTAssertEqual(subject.language, "Ruby")

        let org = try XCTUnwrap(subject.organization)
        XCTAssertEqual(org.login, "github")
        XCTAssertEqual(org.id, 1)
        XCTAssertEqual(org.url, "https://api.github.com/orgs/github")
        XCTAssertEqual(org.type, "Organization")
    }

    func testUserParsingForkedRepository() {
        let subject = Helper.codableFromFile("forked_repo", type: Repository.self)
        XCTAssertEqual(subject.owner.login, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4_672_699)

        XCTAssertEqual(subject.id, 10_824_974)
        XCTAssertEqual(subject.name, "TestFork")
        XCTAssertEqual(subject.fullName, "mietzmithut/TestFork")
        XCTAssertEqual(subject.isPrivate, false)
        XCTAssertEqual(subject.repositoryDescription, "")
        XCTAssertTrue(subject.isFork)
        XCTAssertEqual(subject.gitURL, "git://github.com/mietzmithut/TestFork.git")
        XCTAssertEqual(subject.sshURL, "git@github.com:mietzmithut/TestFork.git")
        XCTAssertEqual(subject.cloneURL, "https://github.com/mietzmithut/TestFork.git")
        XCTAssertEqual(subject.size, 132)
        XCTAssertFalse(try XCTUnwrap(subject.hasWiki))
        XCTAssertEqual(subject.language, "Ruby")
    }

    func testContentFileParsing() {
        let subject = Helper.codableFromFile("content", type: ContentResponse.self)
        guard case let .contentFile(content) = subject else { return }

        XCTAssertEqual(content.url, "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift?ref=main")
        XCTAssertEqual(content.type, "file")
        XCTAssertEqual(content.size, 768)
        XCTAssertEqual(content.downloadUrl, "https://raw.githubusercontent.com/nerdishbynature/octokit.swift/main/Package.swift")
        XCTAssertEqual(content.sha, "7ff4c2ce2bce119effa766ba6845200f59e17414")
        XCTAssertEqual(content.path, "Package.swift")
        XCTAssertEqual(content.htmlUrl, "https://github.com/nerdishbynature/octokit.swift/blob/main/Package.swift")
        XCTAssertEqual(content.gitUrl, "https://api.github.com/repos/nerdishbynature/octokit.swift/git/blobs/7ff4c2ce2bce119effa766ba6845200f59e17414")
        XCTAssertEqual(content.encoding, "base64")
        XCTAssertEqual(content.downloadUrl, "https://raw.githubusercontent.com/nerdishbynature/octokit.swift/main/Package.swift")
        XCTAssertEqual(content.content,
                       "Ly8gc3dpZnQtdG9vbHMtdmVyc2lvbjo0LjAKLy8gVGhlIHN3aWZ0LXRvb2xz\nLXZlcnNpb24gZGVjbGFyZXMgdGhlIG1pbmltdW0gdmVyc2lvbiBvZiBTd2lm\ndCByZXF1aXJlZCB0byBidWlsZCB0aGlzIHBhY2thZ2UuCgppbXBvcnQgUGFj\na2FnZURlc2NyaXB0aW9uCgpsZXQgcGFja2FnZSA9IFBhY2thZ2UoCiAgICBu\nYW1lOiAiT2N0b0tpdCIsCgogICAgcHJvZHVjdHM6IFsKICAgICAgICAubGli\ncmFyeSgKICAgICAgICAgICAgbmFtZTogIk9jdG9LaXQiLAogICAgICAgICAg\nICB0YXJnZXRzOiBbIk9jdG9LaXQiXQogICAgICAgICksCiAgICBdLAogICAg\nZGVwZW5kZW5jaWVzOiBbCiAgICAgICAgLnBhY2thZ2UodXJsOiAiaHR0cHM6\nLy9naXRodWIuY29tL25lcmRpc2hieW5hdHVyZS9SZXF1ZXN0S2l0LmdpdCIs\nIGZyb206ICIzLjMuMCIpLAogICAgICAgIC5wYWNrYWdlKHVybDogImh0dHBz\nOi8vZ2l0aHViLmNvbS9uaWNrbG9ja3dvb2QvU3dpZnRGb3JtYXQiLCBmcm9t\nOiAiMC41Mi44IikKICAgIF0sCiAgICB0YXJnZXRzOiBbCiAgICAgICAgLnRh\ncmdldCgKICAgICAgICAgICAgbmFtZTogIk9jdG9LaXQiLAogICAgICAgICAg\nICBkZXBlbmRlbmNpZXM6IFsiUmVxdWVzdEtpdCJdLAogICAgICAgICAgICBw\nYXRoOiAiT2N0b0tpdCIKICAgICAgICApLAogICAgICAgIC50ZXN0VGFyZ2V0\nKAogICAgICAgICAgICBuYW1lOiAiT2N0b0tpdFRlc3RzIiwKICAgICAgICAg\nICAgZGVwZW5kZW5jaWVzOiBbIk9jdG9LaXQiXQogICAgICAgICksCiAgICBd\nCikK\n")
        XCTAssertEqual(content.links.git, "https://api.github.com/repos/nerdishbynature/octokit.swift/git/blobs/7ff4c2ce2bce119effa766ba6845200f59e17414")
        XCTAssertEqual(content.links.html, "https://github.com/nerdishbynature/octokit.swift/blob/main/Package.swift")
        XCTAssertEqual(content.links.selfLink, "https://api.github.com/repos/nerdishbynature/octokit.swift/contents/Package.swift?ref=main")
    }

    func testContentDirectoryParsing() {
        let subject = Helper.codableFromFile("contents", type: ContentResponse.self)
        guard case let .contentDirectory(contentItems) = subject else { return }
        XCTAssertEqual(contentItems.count, 21)
        XCTAssertEqual(contentItems[0].name, ".devcontainer")
        XCTAssertEqual(contentItems[1].name, ".github")
        XCTAssertEqual(contentItems[2].name, ".gitignore")
        XCTAssertEqual(contentItems[3].name, ".swift-version")
        XCTAssertEqual(contentItems[4].name, ".swiftformat")
        XCTAssertEqual(contentItems[5].name, "Cartfile")
        XCTAssertEqual(contentItems[6].name, "Cartfile.resolved")
        XCTAssertEqual(contentItems[7].name, "Gemfile")
        XCTAssertEqual(contentItems[8].name, "Gemfile.lock")
        XCTAssertEqual(contentItems[9].name, "LICENSE")
        XCTAssertEqual(contentItems[10].name, "Makefile")
        XCTAssertEqual(contentItems[11].name, "OctoKit.swift.podspec")
        XCTAssertEqual(contentItems[12].name, "OctoKit.xcodeproj")
        XCTAssertEqual(contentItems[13].name, "OctoKit")
        XCTAssertEqual(contentItems[14].name, "OctoKitCLI")
        XCTAssertEqual(contentItems[15].name, "Package.resolved")
        XCTAssertEqual(contentItems[16].name, "Package.swift")
        XCTAssertEqual(contentItems[17].name, "README.md")
        XCTAssertEqual(contentItems[18].name, "Script")
        XCTAssertEqual(contentItems[19].name, "Tests")
        XCTAssertEqual(contentItems[20].name, "fastlane")
    }

    func testSubmoduleContentParsing() {
        let subject = Helper.codableFromFile("content_submodule", type: ContentResponse.self)
        guard case let .submoduleContent(submoduleContent) = subject else { return }
        XCTAssertEqual(submoduleContent.url, "https://api.github.com/repos/muter-mutation-testing/muter/contents/homebrew-formulae?ref=master")
        XCTAssertEqual(submoduleContent.type, "submodule")
        XCTAssertEqual(submoduleContent.submoduleGitUrl, "https://github.com/muter-mutation-testing/homebrew-formulae.git")
        XCTAssertEqual(submoduleContent.size, 0)
        XCTAssertEqual(submoduleContent.sha, "4e30ce4a9b6137502cf131664d412000bdd93007")
        XCTAssertEqual(submoduleContent.path, "homebrew-formulae")
        XCTAssertEqual(submoduleContent.name, "homebrew-formulae")
        XCTAssertEqual(submoduleContent.htmlUrl, "https://github.com/muter-mutation-testing/homebrew-formulae/tree/4e30ce4a9b6137502cf131664d412000bdd93007")
        XCTAssertEqual(submoduleContent.gitUrl, "https://api.github.com/repos/muter-mutation-testing/homebrew-formulae/git/trees/4e30ce4a9b6137502cf131664d412000bdd93007")
        XCTAssertEqual(submoduleContent.downloadUrl, nil)
        XCTAssertEqual(submoduleContent.links.git, "https://api.github.com/repos/muter-mutation-testing/homebrew-formulae/git/trees/4e30ce4a9b6137502cf131664d412000bdd93007")
        XCTAssertEqual(submoduleContent.links.html, "https://github.com/muter-mutation-testing/homebrew-formulae/tree/4e30ce4a9b6137502cf131664d412000bdd93007")
        XCTAssertEqual(submoduleContent.links.selfLink, "https://api.github.com/repos/muter-mutation-testing/muter/contents/homebrew-formulae?ref=master")
    }
}
