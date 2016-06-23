import RequestKit
import XCTest

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}

class OctoKitURLTestSession: RequestKitURLSession {
    var wasCalled: Bool = false
    let expectedURL: String
    let expectedHTTPMethod: String
    let responseString: String?
    let statusCode: Int

    init(expectedURL: String, expectedHTTPMethod: String, response: String?, statusCode: Int) {
        self.expectedURL = expectedURL
        self.expectedHTTPMethod = expectedHTTPMethod
        self.responseString = response
        self.statusCode = statusCode
    }

    init(expectedURL: String, expectedHTTPMethod: String, jsonFile: String?, statusCode: Int) {
        self.expectedURL = expectedURL
        self.expectedHTTPMethod = expectedHTTPMethod
        if let jsonFile = jsonFile {
            self.responseString = Helper.stringFromFile(jsonFile)
        } else {
            self.responseString = nil
        }
        self.statusCode = statusCode
    }

    func dataTaskWithRequest(_ request: URLRequest, completionHandler: (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
        XCTAssertEqual(request.httpMethod, expectedHTTPMethod)
        let data = responseString?.data(using: String.Encoding.utf8)
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "http/1.1", headerFields: ["Content-Type": "application/json"])
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }

    func uploadTaskWithRequest(_ request: URLRequest, fromData bodyData: Data?, completionHandler: (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
        XCTAssertEqual(request.httpMethod, expectedHTTPMethod)
        let data = responseString?.data(using: String.Encoding.utf8)
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "http/1.1", headerFields: ["Content-Type": "application/json"])
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }
}

