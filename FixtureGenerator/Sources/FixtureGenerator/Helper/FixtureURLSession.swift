import RequestKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class FixtureURLSession: RequestKitURLSession {
    private let session: URLSession
    private(set) var usedURL: URL? = nil
    private(set) var usedHTTPMethod: String? = nil
    private(set) var usedHTTPHeaders: [String: String]? = nil
    private(set) var response: String? = nil

    init(session: URLSession = .shared) {
        self.session = session
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                self.response = String(data: data, encoding: .utf8)
            }
        }

        return task
    }

    func uploadTask(with request: URLRequest, fromData data: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let task = session.uploadTask(with: request, fromData: data) { data, response, error in
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

        let response = try await session.data(for: request)
        self.response = String(data: response.0, encoding: .utf8)

        return response
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func upload(for request: URLRequest, from data: Data, delegate _: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        usedURL = request.url
        usedHTTPMethod = request.httpMethod
        usedHTTPHeaders = request.allHTTPHeaderFields

        let response = try await session.upload(for: request, from: data)
        self.response = String(data: response.0, encoding: .utf8)

        return response
    }
    #endif
}
