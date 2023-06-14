import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct Octokit {
    public let configuration: TokenConfiguration
    public let session: RequestKitURLSession

    public init(_ config: TokenConfiguration = TokenConfiguration(), session: RequestKitURLSession = URLSession.shared) {
        configuration = config
        self.session = session
    }
}
