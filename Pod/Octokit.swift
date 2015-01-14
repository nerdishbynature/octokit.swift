import Foundation
import Alamofire

public struct Octokit {
    public let configuration: TokenConfiguration

    public init(_ config: TokenConfiguration = TokenConfiguration(token: "token")) {
        configuration = config
    }
}
