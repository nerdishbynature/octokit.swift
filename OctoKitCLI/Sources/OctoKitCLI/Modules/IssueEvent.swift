import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct IssueEvent: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Operate on Issue Events",
                                                    subcommands: [
                                                        GetList.self,
                                                        GetRepoList.self,
                                                        Get.self
                                                    ])

    init() {}
}

@available(macOS 12.0, *)
extension IssueEvent {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The number of the issue")
        var issueNumber: Int

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.issueEvents(owner: owner, repository: repository, issueNumber: issueNumber)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetRepoList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.repositoryIssueEvents(owner: owner, repository: repository)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The event ID")
        var id: Int

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.issueEvent(owner: owner, repository: repository, id: id)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
