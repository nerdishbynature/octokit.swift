//
//  ReviewTests.swift
//  OctoKitTests
//
//  Created by Franco Meloni on 08/02/2020.
//  Copyright © 2020 nerdish by nature. All rights reserved.
//

import OctoKit
import XCTest

class ReviewTests: XCTestCase {
    func testReviews() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews", expectedHTTPMethod: "GET", jsonFile: "reviews", statusCode: 201)
        let task = Octokit().listReviews(session, owner: "octocat", repository: "Hello-World", pullRequestNumber: 1) { response in
            switch response {
            case let .success(reviews):
                let review = reviews.first
                XCTAssertEqual(review?.body, "Here is the body for the review.")
                XCTAssertEqual(review?.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
                XCTAssertEqual(review?.id, 80)
                XCTAssertEqual(review?.state, .approved)
                XCTAssertEqual(review?.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
                XCTAssertEqual(review?.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
                XCTAssertNil(review?.user.blog)
                XCTAssertNil(review?.user.company)
                XCTAssertNil(review?.user.email)
                XCTAssertEqual(review?.user.gravatarID, "")
                XCTAssertEqual(review?.user.id, 1)
                XCTAssertNil(review?.user.location)
                XCTAssertEqual(review?.user.login, "octocat")
                XCTAssertNil(review?.user.name)
                XCTAssertNil(review?.user.numberOfPublicGists)
                XCTAssertNil(review?.user.numberOfPublicRepos)
                XCTAssertNil(review?.user.numberOfPrivateRepos)
                XCTAssertEqual(review?.user.type, "User")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testReviewsAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews", expectedHTTPMethod: "GET", jsonFile: "reviews", statusCode: 201)
        let reviews = try await Octokit().reviews(session, owner: "octocat", repository: "Hello-World", pullRequestNumber: 1)
        let review = reviews.first
        XCTAssertEqual(review?.body, "Here is the body for the review.")
        XCTAssertEqual(review?.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
        XCTAssertEqual(review?.id, 80)
        XCTAssertEqual(review?.state, .approved)
        XCTAssertEqual(review?.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
        XCTAssertEqual(review?.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
        XCTAssertNil(review?.user.blog)
        XCTAssertNil(review?.user.company)
        XCTAssertNil(review?.user.email)
        XCTAssertEqual(review?.user.gravatarID, "")
        XCTAssertEqual(review?.user.id, 1)
        XCTAssertNil(review?.user.location)
        XCTAssertEqual(review?.user.login, "octocat")
        XCTAssertNil(review?.user.name)
        XCTAssertNil(review?.user.numberOfPublicGists)
        XCTAssertNil(review?.user.numberOfPublicRepos)
        XCTAssertNil(review?.user.numberOfPrivateRepos)
        XCTAssertEqual(review?.user.type, "User")
        XCTAssertTrue(session.wasCalled)
    }
    #endif

    func testPostReview() {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews", expectedHTTPMethod: "POST", jsonFile: "review", statusCode: 200)
        let task = Octokit().postReview(
            session,
            owner: "octocat",
            repository: "Hello-World",
            pullRequestNumber: 1,
            event: .approve
        ) {
            switch $0 {
            case let .success(review):
                XCTAssertEqual(review.body, "Here is the body for the review.")
                XCTAssertEqual(review.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
                XCTAssertEqual(review.id, 80)
                XCTAssertEqual(review.state, .approved)
                XCTAssertEqual(review.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
                XCTAssertEqual(review.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
                XCTAssertNil(review.user.blog)
                XCTAssertNil(review.user.company)
                XCTAssertNil(review.user.email)
                XCTAssertEqual(review.user.gravatarID, "")
                XCTAssertEqual(review.user.id, 1)
                XCTAssertNil(review.user.location)
                XCTAssertEqual(review.user.login, "octocat")
                XCTAssertNil(review.user.name)
                XCTAssertNil(review.user.numberOfPublicGists)
                XCTAssertNil(review.user.numberOfPublicRepos)
                XCTAssertNil(review.user.numberOfPrivateRepos)
                XCTAssertEqual(review.user.type, "User")
            case .failure:
                XCTFail("should not get an error")
            }
        }
        XCTAssertNotNil(task)
        XCTAssertTrue(session.wasCalled)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func testPostReviewAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/pulls/1/reviews", expectedHTTPMethod: "POST", jsonFile: "review", statusCode: 200)
        let review = try await Octokit().postReview(
            session,
            owner: "octocat",
            repository: "Hello-World",
            pullRequestNumber: 1,
            event: .approve
        )
        XCTAssertEqual(review.body, "Here is the body for the review.")
        XCTAssertEqual(review.commitID, "ecdd80bb57125d7ba9641ffaa4d7d2c19d3f3091")
        XCTAssertEqual(review.id, 80)
        XCTAssertEqual(review.state, .approved)
        XCTAssertEqual(review.submittedAt, Date(timeIntervalSince1970: 1_574_012_623.0))
        XCTAssertEqual(review.user.avatarURL, "https://github.com/images/error/octocat_happy.gif")
        XCTAssertNil(review.user.blog)
        XCTAssertNil(review.user.company)
        XCTAssertNil(review.user.email)
        XCTAssertEqual(review.user.gravatarID, "")
        XCTAssertEqual(review.user.id, 1)
        XCTAssertNil(review.user.location)
        XCTAssertEqual(review.user.login, "octocat")
        XCTAssertNil(review.user.name)
        XCTAssertNil(review.user.numberOfPublicGists)
        XCTAssertNil(review.user.numberOfPublicRepos)
        XCTAssertNil(review.user.numberOfPrivateRepos)
        XCTAssertEqual(review.user.type, "User")
        XCTAssertTrue(session.wasCalled)
    }
    #endif
}
