import Foundation
import RequestKit

public struct Octokit {
    public let configuration: Configuration

    public init(_ config: Configuration = TokenConfiguration()) {
        configuration = config
    }
}
