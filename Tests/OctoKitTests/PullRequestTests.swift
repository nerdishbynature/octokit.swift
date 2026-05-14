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
                XCTAssertEqual(pullRequests.id, 27304926)
                XCTAssertEqual(pullRequests.title, "Authenticatio")
                XCTAssertEqual(pullRequests.body, "Missing:\n- [x] Error handling\n- [x] Network tests (using Nocilla)\n- [x] Documentation\n")
                XCTAssertEqual(pullRequests.labels?.count, 0)
                XCTAssertEqual(pullRequests.user?.login, "pietbrauer")

                XCTAssertEqual(pullRequests.base?.label, "nerdishbynature:master")
                XCTAssertEqual(pullRequests.base?.ref, "master")
                XCTAssertEqual(pullRequests.base?.sha, "68ddd30a84a0c3f308d794bb96d0c16cc9a7fa2f")
                XCTAssertEqual(pullRequests.base?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.base?.repo?.name, "octokit.swift")

                XCTAssertEqual(pullRequests.head?.label, "nerdishbynature:authenticatio")
                XCTAssertEqual(pullRequests.head?.ref, "authenticatio")
                XCTAssertEqual(pullRequests.head?.sha, "501011a8b8321ac7744818be1434495c4eaf6e38")
                XCTAssertEqual(pullRequests.head?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.head?.repo?.name, "octokit.swift")
                XCTAssertEqual(pullRequests.requestedReviewers?.count, 0)
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
        XCTAssertEqual(pullRequest.id, 27304926)
        XCTAssertEqual(pullRequest.title, "Authenticatio")
        XCTAssertEqual(pullRequest.body, "Missing:\n- [x] Error handling\n- [x] Network tests (using Nocilla)\n- [x] Documentation\n")
        XCTAssertEqual(pullRequest.labels?.count, 0)
        XCTAssertEqual(pullRequest.user?.login, "pietbrauer")

        XCTAssertEqual(pullRequest.base?.label, "nerdishbynature:master")
        XCTAssertEqual(pullRequest.base?.ref, "master")
        XCTAssertEqual(pullRequest.base?.sha, "68ddd30a84a0c3f308d794bb96d0c16cc9a7fa2f")
        XCTAssertEqual(pullRequest.base?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequest.base?.repo?.name, "octokit.swift")

        XCTAssertEqual(pullRequest.head?.label, "nerdishbynature:authenticatio")
        XCTAssertEqual(pullRequest.head?.ref, "authenticatio")
        XCTAssertEqual(pullRequest.head?.sha, "501011a8b8321ac7744818be1434495c4eaf6e38")
        XCTAssertEqual(pullRequest.head?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequest.head?.repo?.name, "octokit.swift")
        XCTAssertEqual(pullRequest.requestedReviewers?.count, 0)
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
                XCTAssertEqual(pullRequests.count, 10)
                XCTAssertEqual(pullRequests.first?.title, "Add paginated variants for list endpoints using RequestKit 3.4.0 load Paginated")
                XCTAssertEqual(pullRequests.first?.body,
                               "Adds *Paginated methods (callback + async) for: myIssues, issues, pullRequests, repositories, myNotifications, listRepositoryNotifications, listReleases, labels. Each returns PaginatedResponse<T> with PageInfo parsed from RFC 5988 Link header.\r\n\r\nUpdates OctoKitURLTestSession to accept responseHeaders so tests can inject Link headers and assert pageInfo.hasNextPage. Adds README pagination section with single-page and fetch-all-pages examples.")
                XCTAssertEqual(pullRequests.first?.labels?.count, 0)
                XCTAssertEqual(pullRequests.first?.user?.login, "pietbrauer")

                XCTAssertEqual(pullRequests.first?.base?.label, "nerdishbynature:main")
                XCTAssertEqual(pullRequests.first?.base?.ref, "main")
                XCTAssertEqual(pullRequests.first?.base?.sha, "69f93724c8b007ef50089935bc06526c5fb9a750")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "octokit.swift")

                XCTAssertEqual(pullRequests.first?.head?.label, "nerdishbynature:feature/requestkit-3.4.0-pagination")
                XCTAssertEqual(pullRequests.first?.head?.ref, "feature/requestkit-3.4.0-pagination")
                XCTAssertEqual(pullRequests.first?.head?.sha, "ef7ef06583be6c70b95a59250c59a72f4b73171e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "octokit.swift")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?.count, 0)
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
        XCTAssertEqual(pullRequests.count, 10)
        XCTAssertEqual(pullRequests.first?.title, "Add paginated variants for list endpoints using RequestKit 3.4.0 load Paginated")
        XCTAssertEqual(pullRequests.first?.body,
                       "Adds *Paginated methods (callback + async) for: myIssues, issues, pullRequests, repositories, myNotifications, listRepositoryNotifications, listReleases, labels. Each returns PaginatedResponse<T> with PageInfo parsed from RFC 5988 Link header.\r\n\r\nUpdates OctoKitURLTestSession to accept responseHeaders so tests can inject Link headers and assert pageInfo.hasNextPage. Adds README pagination section with single-page and fetch-all-pages examples.")
        XCTAssertEqual(pullRequests.first?.labels?.count, 0)
        XCTAssertEqual(pullRequests.first?.user?.login, "pietbrauer")

        XCTAssertEqual(pullRequests.first?.base?.label, "nerdishbynature:main")
        XCTAssertEqual(pullRequests.first?.base?.ref, "main")
        XCTAssertEqual(pullRequests.first?.base?.sha, "69f93724c8b007ef50089935bc06526c5fb9a750")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "octokit.swift")

        XCTAssertEqual(pullRequests.first?.head?.label, "nerdishbynature:feature/requestkit-3.4.0-pagination")
        XCTAssertEqual(pullRequests.first?.head?.ref, "feature/requestkit-3.4.0-pagination")
        XCTAssertEqual(pullRequests.first?.head?.sha, "ef7ef06583be6c70b95a59250c59a72f4b73171e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "octokit.swift")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?.count, 0)
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
                XCTAssertEqual(pullRequests.count, 10)
                XCTAssertEqual(pullRequests.first?.title, "Add paginated variants for list endpoints using RequestKit 3.4.0 load Paginated")
                XCTAssertEqual(pullRequests.first?.body,
                               "Adds *Paginated methods (callback + async) for: myIssues, issues, pullRequests, repositories, myNotifications, listRepositoryNotifications, listReleases, labels. Each returns PaginatedResponse<T> with PageInfo parsed from RFC 5988 Link header.\r\n\r\nUpdates OctoKitURLTestSession to accept responseHeaders so tests can inject Link headers and assert pageInfo.hasNextPage. Adds README pagination section with single-page and fetch-all-pages examples.")
                XCTAssertEqual(pullRequests.first?.labels?.count, 0)
                XCTAssertEqual(pullRequests.first?.user?.login, "pietbrauer")

                XCTAssertEqual(pullRequests.first?.base?.label, "nerdishbynature:main")
                XCTAssertEqual(pullRequests.first?.base?.ref, "main")
                XCTAssertEqual(pullRequests.first?.base?.sha, "69f93724c8b007ef50089935bc06526c5fb9a750")
                XCTAssertEqual(pullRequests.first?.base?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.first?.base?.repo?.name, "octokit.swift")

                XCTAssertEqual(pullRequests.first?.head?.label, "nerdishbynature:feature/requestkit-3.4.0-pagination")
                XCTAssertEqual(pullRequests.first?.head?.ref, "feature/requestkit-3.4.0-pagination")
                XCTAssertEqual(pullRequests.first?.head?.sha, "ef7ef06583be6c70b95a59250c59a72f4b73171e")
                XCTAssertEqual(pullRequests.first?.head?.user?.login, "nerdishbynature")
                XCTAssertEqual(pullRequests.first?.head?.repo?.name, "octokit.swift")
                XCTAssertEqual(pullRequests.first?.requestedReviewers?.count, 0)
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
        XCTAssertEqual(pullRequests.count, 10)
        XCTAssertEqual(pullRequests.first?.title, "Add paginated variants for list endpoints using RequestKit 3.4.0 load Paginated")
        XCTAssertEqual(pullRequests.first?.body,
                       "Adds *Paginated methods (callback + async) for: myIssues, issues, pullRequests, repositories, myNotifications, listRepositoryNotifications, listReleases, labels. Each returns PaginatedResponse<T> with PageInfo parsed from RFC 5988 Link header.\r\n\r\nUpdates OctoKitURLTestSession to accept responseHeaders so tests can inject Link headers and assert pageInfo.hasNextPage. Adds README pagination section with single-page and fetch-all-pages examples.")
        XCTAssertEqual(pullRequests.first?.labels?.count, 0)
        XCTAssertEqual(pullRequests.first?.user?.login, "pietbrauer")

        XCTAssertEqual(pullRequests.first?.base?.label, "nerdishbynature:main")
        XCTAssertEqual(pullRequests.first?.base?.ref, "main")
        XCTAssertEqual(pullRequests.first?.base?.sha, "69f93724c8b007ef50089935bc06526c5fb9a750")
        XCTAssertEqual(pullRequests.first?.base?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequests.first?.base?.repo?.name, "octokit.swift")

        XCTAssertEqual(pullRequests.first?.head?.label, "nerdishbynature:feature/requestkit-3.4.0-pagination")
        XCTAssertEqual(pullRequests.first?.head?.ref, "feature/requestkit-3.4.0-pagination")
        XCTAssertEqual(pullRequests.first?.head?.sha, "ef7ef06583be6c70b95a59250c59a72f4b73171e")
        XCTAssertEqual(pullRequests.first?.head?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullRequests.first?.head?.repo?.name, "octokit.swift")
        XCTAssertEqual(pullRequests.first?.requestedReviewers?.count, 0)
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
                    XCTAssertEqual(pullrequest.id, 27304926)
                    XCTAssertEqual(pullrequest.title, "Authenticatio")
                    XCTAssertEqual(pullrequest.body, "Missing:\n- [x] Error handling\n- [x] Network tests (using Nocilla)\n- [x] Documentation\n")
                    XCTAssertEqual(pullrequest.labels?.count, 0)
                    XCTAssertEqual(pullrequest.user?.login, "pietbrauer")

                    XCTAssertEqual(pullrequest.base?.label, "nerdishbynature:master")
                    XCTAssertEqual(pullrequest.base?.ref, "master")
                    XCTAssertEqual(pullrequest.base?.sha, "68ddd30a84a0c3f308d794bb96d0c16cc9a7fa2f")
                    XCTAssertEqual(pullrequest.base?.user?.login, "nerdishbynature")
                    XCTAssertEqual(pullrequest.base?.repo?.name, "octokit.swift")

                    XCTAssertEqual(pullrequest.head?.label, "nerdishbynature:authenticatio")
                    XCTAssertEqual(pullrequest.head?.ref, "authenticatio")
                    XCTAssertEqual(pullrequest.head?.sha, "501011a8b8321ac7744818be1434495c4eaf6e38")
                    XCTAssertEqual(pullrequest.head?.user?.login, "nerdishbynature")
                    XCTAssertEqual(pullrequest.head?.repo?.name, "octokit.swift")
                    XCTAssertEqual(pullrequest.requestedReviewers?.count, 0)
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

        XCTAssertEqual(pullrequest.id, 27304926)
        XCTAssertEqual(pullrequest.title, "Authenticatio")
        XCTAssertEqual(pullrequest.body, "Missing:\n- [x] Error handling\n- [x] Network tests (using Nocilla)\n- [x] Documentation\n")
        XCTAssertEqual(pullrequest.labels?.count, 0)
        XCTAssertEqual(pullrequest.user?.login, "pietbrauer")

        XCTAssertEqual(pullrequest.base?.label, "nerdishbynature:master")
        XCTAssertEqual(pullrequest.base?.ref, "master")
        XCTAssertEqual(pullrequest.base?.sha, "68ddd30a84a0c3f308d794bb96d0c16cc9a7fa2f")
        XCTAssertEqual(pullrequest.base?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullrequest.base?.repo?.name, "octokit.swift")

        XCTAssertEqual(pullrequest.head?.label, "nerdishbynature:authenticatio")
        XCTAssertEqual(pullrequest.head?.ref, "authenticatio")
        XCTAssertEqual(pullrequest.head?.sha, "501011a8b8321ac7744818be1434495c4eaf6e38")
        XCTAssertEqual(pullrequest.head?.user?.login, "nerdishbynature")
        XCTAssertEqual(pullrequest.head?.repo?.name, "octokit.swift")
        XCTAssertEqual(pullrequest.requestedReviewers?.count, 0)
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
                                            jsonFile: "pull_request_files",
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
                                            jsonFile: "pull_request_files",
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

    func testReadPullRequestReviewComments() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/comments?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request_comments",
                                            statusCode: 200)
        let task = Octokit(session: session).readPullRequestReviewComments(owner: "octokat",
                                                                           repository: "Hello-World",
                                                                           number: 1347) { response in
            switch response {
            case let .success(comments):
                XCTAssertEqual(comments.count, 1)
                let comment = comments.first
                XCTAssertNotNil(comment)
                XCTAssertEqual(comment?.body, "Great stuff!")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testReadPullRequestReviewCommentsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/comments?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request_comments",
                                            statusCode: 200)
        let comments = try await Octokit(session: session).readPullRequestReviewComments(owner: "octokat",
                                                                                         repository: "Hello-World",
                                                                                         number: 1347)
        XCTAssertEqual(comments.count, 1)
        let comment = try XCTUnwrap(comments.first)
        XCTAssertNotNil(comment)
        XCTAssertEqual(comment.body, "Great stuff!")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testCreatePullRequestReviewComment() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/comments",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "pull_request_comment",
                                            statusCode: 200)
        let task = Octokit(session: session).createPullRequestReviewComment(owner: "octokat",
                                                                            repository: "Hello-World",
                                                                            number: 1347,
                                                                            commitId: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                                                            path: "file1.txt",
                                                                            line: 2,
                                                                            body: "Great stuff!") { response in
            switch response {
            case let .success(comment):
                XCTAssertEqual(comment.body, "Great stuff!")
                XCTAssertEqual(comment.commitId, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
                XCTAssertEqual(comment.line, 2)
                XCTAssertEqual(comment.startLine, 1)
                XCTAssertEqual(comment.side, .right)
                XCTAssertNil(comment.subjectType)
                XCTAssertEqual(comment.inReplyToId, 8)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }

        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testCreatePullRequestReviewCommentAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/comments",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "pull_request_comment",
                                            statusCode: 200)
        let comment = try await Octokit(session: session).createPullRequestReviewComment(owner: "octokat",
                                                                                         repository: "Hello-World",
                                                                                         number: 1347,
                                                                                         commitId: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
                                                                                         path: "file1.txt",
                                                                                         line: 2,
                                                                                         body: "Great stuff!")
        XCTAssertEqual(comment.body, "Great stuff!")
        XCTAssertEqual(comment.commitId, "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(comment.line, 2)
        XCTAssertEqual(comment.startLine, 1)
        XCTAssertEqual(comment.side, .right)
        XCTAssertNil(comment.subjectType)
        XCTAssertEqual(comment.inReplyToId, 8)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testCreatePullRequestRegularComment() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/issues/1347/comments",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "pull_request_comment",
                                            statusCode: 200)
        let task = Octokit(session: session).createPullRequestReviewComment(owner: "octokat",
                                                                            repository: "Hello-World",
                                                                            number: 1347,
                                                                            body: "Great stuff!") { response in
            switch response {
            case let .success(comment):
                XCTAssertEqual(comment.body, "Great stuff!")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }

        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testCreatePullRequestRegularCommentAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/issues/1347/comments",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "pull_request_comment",
                                            statusCode: 200)
        let comment = try await Octokit(session: session).createPullRequestReviewComment(owner: "octokat",
                                                                                         repository: "Hello-World",
                                                                                         number: 1347,
                                                                                         body: "Great stuff!")
        XCTAssertEqual(comment.body, "Great stuff!")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testReadPullRequestRequestedReviewers() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/requested_reviewers?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request_requested_reviewers",
                                            statusCode: 200)
        let task = Octokit(session: session).readPullRequestRequestedReviewers(owner: "octokat",
                                                                               repository: "Hello-World",
                                                                               number: 1347) { response in
            switch response {
            case let .success(requestedReviewers):
                XCTAssertEqual(requestedReviewers.users.count, 1)
                XCTAssertEqual(requestedReviewers.users.first?.login, "octocat")
                XCTAssertEqual(requestedReviewers.teams.count, 1)
                XCTAssertEqual(requestedReviewers.teams.first?.name, "Justice League")
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testReadPullRequestRequestedReviewersAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octokat/Hello-World/pulls/1347/requested_reviewers?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_request_requested_reviewers",
                                            statusCode: 200)
        let requestedReviewers = try await Octokit(session: session).readPullRequestRequestedReviewers(owner: "octokat",
                                                                                                       repository: "Hello-World",
                                                                                                       number: 1347)
        XCTAssertEqual(requestedReviewers.users.count, 1)
        let user = try XCTUnwrap(requestedReviewers.users.first)
        XCTAssertEqual(user.login, "octocat")
        XCTAssertEqual(requestedReviewers.teams.count, 1)
        let team = try XCTUnwrap(requestedReviewers.teams.first)
        XCTAssertEqual(team.name, "Justice League")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testGetPullRequestsPaginated() {
        let linkHeader = "<https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&sort=created&state=open&page=2>; rel=\"next\""
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200,
                                            responseHeaders: ["Content-Type": "application/json", "Link": linkHeader])
        let task = Octokit(session: session).pullRequestsPaginated(owner: "octocat", repository: "Hello-World") { response in
            switch response {
            case let .success(paginated):
                XCTAssertFalse(paginated.values.isEmpty)
                XCTAssertTrue(paginated.pageInfo.hasNextPage)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testGetPullRequestsPaginatedAsync() async throws {
        let linkHeader = "<https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&sort=created&state=open&page=2>; rel=\"next\""
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls?direction=desc&sort=created&state=open",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "pull_requests",
                                            statusCode: 200,
                                            responseHeaders: ["Content-Type": "application/json", "Link": linkHeader])
        let paginated = try await Octokit(session: session).pullRequestsPaginated(owner: "octocat", repository: "Hello-World")
        XCTAssertFalse(paginated.values.isEmpty)
        XCTAssertTrue(paginated.pageInfo.hasNextPage)
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
