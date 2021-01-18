import RequestKit
import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    fileprivate(set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}

class OctoKitURLTestSession: RequestKitURLSession {
    var wasCalled: Bool = false
    let expectedURL: String
    let expectedHTTPMethod: String
    let expectedHTTPHeaders: [String: String]
    let responseString: String?
    let statusCode: Int

    init(
        expectedURL: String,
        expectedHTTPMethod: String,
        expectedHTTPHeaders: [String: String] = [:],
        response: String?,
        statusCode: Int
    ) {
        self.expectedURL = expectedURL
        self.expectedHTTPMethod = expectedHTTPMethod
        self.expectedHTTPHeaders = expectedHTTPHeaders
        responseString = response
        self.statusCode = statusCode
    }

    init(
        expectedURL: String,
        expectedHTTPMethod: String,
        expectedHTTPHeaders: [String: String] = [:],
        jsonFile: String?,
        statusCode: Int
    ) {
        self.expectedURL = expectedURL
        self.expectedHTTPMethod = expectedHTTPMethod
        self.expectedHTTPHeaders = expectedHTTPHeaders
        if let jsonFile = jsonFile {
            responseString = Helper.stringFromFile(jsonFile)
        } else {
            responseString = nil
        }
        self.statusCode = statusCode
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
        XCTAssertEqual(request.httpMethod, expectedHTTPMethod)

        for (key, value) in expectedHTTPHeaders {
            XCTAssertEqual(request.allHTTPHeaderFields?[key], value)
        }

        let data = responseString?.data(using: String.Encoding.utf8)
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: "http/1.1",
            headerFields: ["Content-Type": "application/json"]
        )
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }

    func uploadTask(
        with request: URLRequest,
        fromData _: Data?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
        XCTAssertEqual(request.httpMethod, expectedHTTPMethod)

        for (key, value) in expectedHTTPHeaders {
            XCTAssertEqual(request.allHTTPHeaderFields?[key], value)
        }

        let data = responseString?.data(using: String.Encoding.utf8)
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: "http/1.1",
            headerFields: ["Content-Type": "application/json"]
        )
        completionHandler(data, response, nil)
        wasCalled = true
        return MockURLSessionDataTask()
    }
}
