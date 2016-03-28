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
    let jsonFile: String?
    let statusCode: Int

    init(expectedURL: String, expectedHTTPMethod: String, jsonFile: String?, statusCode: Int) {
        self.expectedURL = expectedURL
        self.expectedHTTPMethod = expectedHTTPMethod
        self.jsonFile = jsonFile
        self.statusCode = statusCode
    }

    func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.URL?.absoluteString, expectedURL)
        XCTAssertEqual(request.HTTPMethod, expectedHTTPMethod)
        var data: NSData? = nil
        if let jsonFile = jsonFile {
            data = Helper.stringFromFile(jsonFile)?.dataUsingEncoding(NSUTF8StringEncoding)
        }

        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: statusCode, HTTPVersion: "http/1.1", headerFields: ["Content-Type": "application/json"])
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }

    func uploadTaskWithRequest(request: NSURLRequest, fromData bodyData: NSData?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.URL?.absoluteString, expectedURL)
        XCTAssertEqual(request.HTTPMethod, expectedHTTPMethod)
        var data: NSData? = nil
        if let jsonFile = jsonFile {
            data = Helper.stringFromFile(jsonFile)?.dataUsingEncoding(NSUTF8StringEncoding)
        }

        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: statusCode, HTTPVersion: "http/1.1", headerFields: ["Content-Type": "application/json"])
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }
}

