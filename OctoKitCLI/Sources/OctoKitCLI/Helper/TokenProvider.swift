import Foundation
import OctoKit

func makeOctokit(session: JSONInterceptingURLSession) -> Octokit {
    if let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] {
        return Octokit(TokenConfiguration(token), session: session)
    }
    return Octokit(session: session)
}
