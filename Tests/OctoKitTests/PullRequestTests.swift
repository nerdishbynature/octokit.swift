import OctoKit
import XCTest

class PullRequestTests: XCTestCase {
    func testGetPullRequest() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let task = Octokit(session: session).pullRequest(owner: "octocat", repository: "Hello-World", number: 1) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.id, 1)
                XCTAssertEqual(pullRequests.title, "new-feature")
                XCTAssertEqual(pullRequests.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.labels?.count, 1)
                XCTAssertEqual(pullRequests.user?.login, "octocat")

                XCTAssertEqual(pullRequests.base?.label, "master")
                XCTAssertEqual(pullRequests.base?.ref, "master")
                XCTAssertEqual(pullRequests.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let pullRequest = try await Octokit(session: session).pullRequest(owner: "octocat", repository: "Hello-World", number: 1)
        XCTAssertEqual(pullRequest.id, 1)
        XCTAssertEqual(pullRequest.title, "new-feature")
        XCTAssertEqual(pullRequest.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequest.labels?.count, 1)
        XCTAssertEqual(pullRequest.user?.login, "octocat")

        XCTAssertEqual(pullRequest.base?.label, "master")
        XCTAssertEqual(pullRequest.base?.ref, "master")
        XCTAssertEqual(pullRequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequest.head?.label, "new-topic")
        XCTAssertEqual(pullRequest.head?.ref, "new-topic")
        XCTAssertEqual(pullRequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequest.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequest.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetPullRequests() {
        // Test filtering with on the base branch

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?base=develop&direction=desc&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200)

        let task = Octokit(session: session).pullRequests(owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.open) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.count, 1)
                XCTAssertEqual(pullRequests.first?.title, "new-feature")
                XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.first?.labels?.count, 1)
                XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

                XCTAssertEqual(pullRequests.first?.base?.label, "master")
                XCTAssertEqual(pullRequests.first?.base?.ref, "master")
                XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.first?.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestsAsync() async throws {
        // Test filtering with on the base branch
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?base=develop&direction=desc&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200)

        let pullRequests = try await Octokit(session: session).pullRequests(owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.open)
        XCTAssertEqual(pullRequests.count, 1)
        XCTAssertEqual(pullRequests.first?.title, "new-feature")
        XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequests.first?.labels?.count, 1)
        XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

        XCTAssertEqual(pullRequests.first?.base?.label, "master")
        XCTAssertEqual(pullRequests.first?.base?.ref, "master")
        XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequests.first?.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetPullRequestWithHead() {
        // Test filtering with on the head branch
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&head=octocat%3Anew-topic&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200)

        let task = Octokit(session: session).pullRequests(owner: "octocat", repository: "Hello-World", head: "octocat:new-topic", state: Openness.open) { response in
            switch response {
            case let .success(pullRequests):
                XCTAssertEqual(pullRequests.count, 1)
                XCTAssertEqual(pullRequests.first?.title, "new-feature")
                XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
                XCTAssertEqual(pullRequests.first?.labels?.count, 1)
                XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

                XCTAssertEqual(pullRequests.first?.base?.label, "master")
                XCTAssertEqual(pullRequests.first?.base?.ref, "master")
                XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
                XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
                XCTAssertEqual(pullRequests.first?.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestsWithHeadAsync() async throws {
        // Test filtering with on the head branch
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&head=octocat%3Anew-topic&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200)

        let pullRequests = try await Octokit(session: session).pullRequests(owner: "octocat", repository: "Hello-World", head: "octocat:new-topic", state: Openness.open)
        XCTAssertEqual(pullRequests.count, 1)
        XCTAssertEqual(pullRequests.first?.title, "new-feature")
        XCTAssertEqual(pullRequests.first?.body, "Please pull these awesome changes")
        XCTAssertEqual(pullRequests.first?.labels?.count, 1)
        XCTAssertEqual(pullRequests.first?.user?.login, "octocat")

        XCTAssertEqual(pullRequests.first?.base?.label, "master")
        XCTAssertEqual(pullRequests.first?.base?.ref, "master")
        XCTAssertEqual(pullRequests.first?.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequests.first?.head?.label, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.ref, "new-topic")
        XCTAssertEqual(pullRequests.first?.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullRequests.first?.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testUpdatePullRequest() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "PATCH",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let task = Octokit(session: session)
            .patchPullRequest(owner: "octocat", repository: "Hello-World", number: 1, title: "new-title", body: "new-body", state: .open, base: "base-branch",
                              mantainerCanModify: true) { response in
                switch response {
                case let .success(pullrequest):
                    XCTAssertEqual(pullrequest.id, 1)
                    XCTAssertEqual(pullrequest.title, "new-feature")
                    XCTAssertEqual(pullrequest.body, "Please pull these awesome changes")
                    XCTAssertEqual(pullrequest.labels?.count, 1)
                    XCTAssertEqual(pullrequest.user?.login, "octocat")

                    XCTAssertEqual(pullrequest.base?.label, "master")
                    XCTAssertEqual(pullrequest.base?.ref, "master")
                    XCTAssertEqual(pullrequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                    XCTAssertEqual(pullrequest.base?.user?.login, "octocat")
                    XCTAssertEqual(pullrequest.base?.repo?.name, "Hello-World")

                    XCTAssertEqual(pullrequest.head?.label, "new-topic")
                    XCTAssertEqual(pullrequest.head?.ref, "new-topic")
                    XCTAssertEqual(pullrequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                    XCTAssertEqual(pullrequest.head?.user?.login, "octocat")
                    XCTAssertEqual(pullrequest.head?.repo?.name, "Hello-World")
                    XCTAssertEqual(pullrequest.requestedReviewers?[0].login, "octocat")
                    XCTAssertEqual(pullrequest.draft, false)
                case let .failure(error):
                    XCTAssertNil(error)
                }
            }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testUpdatePullRequestAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1",
                                            expectedHTTPMethod: "PATCH",
                                            jsonFile: "pull_request",
                                            statusCode: 200)

        let pullrequest = try await Octokit(session: session)
            .patchPullRequest(owner: "octocat", repository: "Hello-World", number: 1, title: "new-title", body: "new-body", state: .open, base: "base-branch", mantainerCanModify: true)

        XCTAssertEqual(pullrequest.id, 1)
        XCTAssertEqual(pullrequest.title, "new-feature")
        XCTAssertEqual(pullrequest.body, "Please pull these awesome changes")
        XCTAssertEqual(pullrequest.labels?.count, 1)
        XCTAssertEqual(pullrequest.user?.login, "octocat")

        XCTAssertEqual(pullrequest.base?.label, "master")
        XCTAssertEqual(pullrequest.base?.ref, "master")
        XCTAssertEqual(pullrequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullrequest.base?.user?.login, "octocat")
        XCTAssertEqual(pullrequest.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullrequest.head?.label, "new-topic")
        XCTAssertEqual(pullrequest.head?.ref, "new-topic")
        XCTAssertEqual(pullrequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullrequest.head?.user?.login, "octocat")
        XCTAssertEqual(pullrequest.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullrequest.requestedReviewers?[0].login, "octocat")
        XCTAssertEqual(pullrequest.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testCreatePullRequest() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "created_pull_request",
                                            statusCode: 200)

        let task = Octokit(session: session).createPullRequest(owner: "octocat",
                                                               repo: "Hello-World",
                                                               title: "Amazing new feature",
                                                               head: "octocat:new-feature",
                                                               base: "master",
                                                               body: "Please pull these awesome changes in!",
                                                               maintainerCanModify: true,
                                                               draft: false) { response in
            switch response {
            case let .success(pullRequest):
                XCTAssertEqual(pullRequest.id, 1)
                XCTAssertEqual(pullRequest.title, "Amazing new feature")
                XCTAssertEqual(pullRequest.body, "Please pull these awesome changes in!")
                XCTAssertEqual(pullRequest.labels?.count, 1)
                XCTAssertEqual(pullRequest.user?.login, "octocat")

                XCTAssertEqual(pullRequest.base?.label, "octocat:master")
                XCTAssertEqual(pullRequest.base?.ref, "master")
                XCTAssertEqual(pullRequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequest.base?.user?.login, "octocat")
                XCTAssertEqual(pullRequest.base?.repo?.name, "Hello-World")

                XCTAssertEqual(pullRequest.head?.label, "octocat:new-topic")
                XCTAssertEqual(pullRequest.head?.ref, "new-topic")
                XCTAssertEqual(pullRequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(pullRequest.head?.user?.login, "octocat")
                XCTAssertEqual(pullRequest.head?.repo?.name, "Hello-World")
                XCTAssertEqual(pullRequest.requestedReviewers?[0].login, "other_user")
                XCTAssertEqual(pullRequest.draft, false)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testCreatePullRequestAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "created_pull_request",
                                            statusCode: 200)

        let pullRequest = try await Octokit(session: session)
            .createPullRequest(owner: "octocat",
                               repo: "Hello-World",
                               title: "Amazing new feature",
                               head: "octocat:new-feature",
                               base: "master",
                               body: "Please pull these awesome changes in!",
                               maintainerCanModify: true,
                               draft: false)

        XCTAssertEqual(pullRequest.id, 1)
        XCTAssertEqual(pullRequest.title, "Amazing new feature")
        XCTAssertEqual(pullRequest.body, "Please pull these awesome changes in!")
        XCTAssertEqual(pullRequest.labels?.count, 1)
        XCTAssertEqual(pullRequest.user?.login, "octocat")

        XCTAssertEqual(pullRequest.base?.label, "octocat:master")
        XCTAssertEqual(pullRequest.base?.ref, "master")
        XCTAssertEqual(pullRequest.base?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.base?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.base?.repo?.name, "Hello-World")

        XCTAssertEqual(pullRequest.head?.label, "octocat:new-topic")
        XCTAssertEqual(pullRequest.head?.ref, "new-topic")
        XCTAssertEqual(pullRequest.head?.sha, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(pullRequest.head?.user?.login, "octocat")
        XCTAssertEqual(pullRequest.head?.repo?.name, "Hello-World")
        XCTAssertEqual(pullRequest.requestedReviewers?[0].login, "other_user")
        XCTAssertEqual(pullRequest.draft, false)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testListPullRequestsFiles() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1347/files",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests_files",
                                            statusCode: 200)

        let task = Octokit(session: session)
            .listPullRequestsFiles(owner: "octocat",
                                   repository: "Hello-World",
                                   number: 1347) { response in
                switch response {
                case let .success(files):
                    XCTAssertEqual(files.count, 1)
                    let file = files.first
                    XCTAssertNotNil(file)
                    XCTAssertEqual(file?.sha, "bbcd538c8e72b8c175046e27cc8f907076331401")
                    XCTAssertEqual(file?.filename, "file1.txt")
                    XCTAssertEqual(file?.status, .added)
                    XCTAssertEqual(file?.additions, 103)
                    XCTAssertEqual(file?.deletions, 21)
                    XCTAssertEqual(file?.changes, 124)
                    XCTAssertEqual(file?.blobUrl, "https://github.com/octocat/Hello-World/blob/6dcb09b5b57875f334f61aebed695e2e4193db5e/file1.txt")
                    XCTAssertEqual(file?.rawUrl, "https://github.com/octocat/Hello-World/raw/6dcb09b5b57875f334f61aebed695e2e4193db5e/file1.txt")
                    XCTAssertEqual(file?.contentsUrl, "https://api.github.com/repos/octocat/Hello-World/contents/file1.txt?ref=6dcb09b5b57875f334f61aebed695e2e4193db5e")
                    XCTAssertEqual(file?.patch, "@@ -132,7 +132,7 @@ module Test @@ -1000,7 +1000,7 @@ module Test")
                case let .failure(error):
                    XCTAssertNil(error)
                }
            }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testListPullRequestsFilesAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1347/files",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests_files",
                                            statusCode: 200)

        let files = try await Octokit(session: session)
            .listPullRequestsFiles(owner: "octocat",
                                   repository: "Hello-World",
                                   number: 1347)
        XCTAssertEqual(files.count, 1)
        let file = files.first
        XCTAssertNotNil(file)
        XCTAssertEqual(file?.sha, "bbcd538c8e72b8c175046e27cc8f907076331401")
        XCTAssertEqual(file?.filename, "file1.txt")
        XCTAssertEqual(file?.status, .added)
        XCTAssertEqual(file?.additions, 103)
        XCTAssertEqual(file?.deletions, 21)
        XCTAssertEqual(file?.changes, 124)
        XCTAssertEqual(file?.blobUrl, "https://github.com/octocat/Hello-World/blob/6dcb09b5b57875f334f61aebed695e2e4193db5e/file1.txt")
        XCTAssertEqual(file?.rawUrl, "https://github.com/octocat/Hello-World/raw/6dcb09b5b57875f334f61aebed695e2e4193db5e/file1.txt")
        XCTAssertEqual(file?.contentsUrl, "https://api.github.com/repos/octocat/Hello-World/contents/file1.txt?ref=6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(file?.patch, "@@ -132,7 +132,7 @@ module Test @@ -1000,7 +1000,7 @@ module Test")

        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
