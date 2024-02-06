//
//  SearchTests.swift
//
//
//  Created by Chidi Williams on 04/02/2024.
//

import OctoKit
import XCTest

final class SearchTests: XCTestCase {
    // MARK: Request Tests

    func testSearchCode() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/search/code?page=1&per_page=100&q=hello%2Brepo%3Aoctocat/hello-world", expectedHTTPMethod: "GET",
                                            jsonFile: "search_code", statusCode: 200)
        let task = Octokit(session: session).searchCode(query: "hello+repo:octocat/hello-world") { response in
            switch response {
            case let .success(result):
                XCTAssertEqual(result.totalCount, 1)
                XCTAssertEqual(result.items.count, 1)
            case let .failure(error):
                print(error)
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testSearchCodeAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/search/code?page=1&per_page=100&q=hello%2Brepo%3Aoctocat/hello-world",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "search_code",
                                            statusCode: 200)
        let response = try await Octokit(session: session).searchCode(query: "hello+repo:octocat/hello-world")
        XCTAssertEqual(response.totalCount, 1)
        XCTAssertEqual(response.items.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testSearchCodeSetsPagination() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/search/code?page=2&per_page=50&q=hello%2Brepo%3Aoctocat/hello-world", expectedHTTPMethod: "GET", jsonFile: nil,
                                            statusCode: 200)
        let task = Octokit(session: session).searchCode(query: "hello+repo:octocat/hello-world", page: "2", perPage: "50") { response in
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
}
