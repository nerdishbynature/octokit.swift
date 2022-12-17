import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class JSONInterceptingURLSession: RequestKitURLSession {
    private let session: RequestKitURLSession
    private(set) var usedURL: URL?
    private(set) var usedHTTPMethod: String?
    private(set) var usedHTTPHeaders: [String: String]?
    private(set) var response: String?

    init(session: RequestKitURLSession = URLSession.shared) {
        self.session = session
    }

    func dataTask(with request: URLRequest, completionHandler _: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let task = session.dataTask(with: request) { data, _, _ in
            if let data = data {
                self.response = String(data: data, encoding: .utf8)
            }
        }

        return task
    }

    func uploadTask(with request: URLRequest, fromData data: Data?, completionHandler _: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let task = session.uploadTask(with: request, fromData: data) { data, _, _ in
            if let data = data {
                self.response = String(data: data, encoding: .utf8)
            }
        }

        return task
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func data(for request: URLRequest, delegate _: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let response = try await session.data(for: request, delegate: nil)
        self.response = String(data: response.0, encoding: .utf8)

        return response
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func upload(for request: URLRequest, from data: Data, delegate _: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let response = try await session.upload(for: request, from: data, delegate: nil)
        self.response = String(data: response.0, encoding: .utf8)

        return response
    }
    #endif
}

extension JSONInterceptingURLSession {
    var verbose: String? {
        guard let usedURL, let usedHTTPMethod else {
            return "No URL or HTTPMethod".red
        }

        return "\(usedHTTPMethod) \(usedURL)".yellow
    }

    func printResponseToFileOrConsole(filePath: String?) throws {
        if let response, let prettyPrinted = response.prettyPrintedJSONString {
            if let filePath {
                try prettyPrinted.write(toFile: filePath, atomically: true, encoding: .utf8)
                print("Put file to \(filePath)".green)
            } else {
                print(prettyPrinted.blue)
            }
        } else {
            print("Received no response.".red)
        }
    }

    func verbosePrint(verbose: Bool) {
        if verbose, let verboseString = self.verbose {
            print(verboseString)
        }
    }
}
