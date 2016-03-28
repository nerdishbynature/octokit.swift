import XCTest
import RequestKit
import OctoKit

class PublicKeyTests: XCTestCase {
    // MARK: Actual Request tests

    func testPostPublicKey() {
        let config = TokenConfiguration("12345")
        let session = PublicKeyTestsSession()
        Octokit(config).postPublicKey(session, publicKey: "test-key", title: "test title") { response in
            switch response {
            case .Success(let publicKey):
                XCTAssertEqual(publicKey, "test-key")
            case .Failure:
                XCTAssert(false, "should not get an error")
            }
        }
        XCTAssertTrue(session.wasCalled)
    }
}

class PublicKeyTestsSession: RequestKitURLSession {
    var wasCalled: Bool = false

    func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTFail("This should not be called")
        return MockURLSessionDataTask()
    }

    func uploadTaskWithRequest(request: NSURLRequest, fromData bodyData: NSData?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.URL?.absoluteString, "https://api.github.com/user/keys?access_token=12345")
        XCTAssertEqual(request.HTTPMethod, "POST")
        let data = Helper.stringFromFile("public_key")?.dataUsingEncoding(NSUTF8StringEncoding)
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 201, HTTPVersion: "http/1.1", headerFields: ["Content-Type": "application/json"])
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }
}
