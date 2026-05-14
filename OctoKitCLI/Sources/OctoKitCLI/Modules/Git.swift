import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct Git: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Operate on Git objects",
                                                    subcommands: [
                                                        GetTree.self,
                                                        GetRefs.self
                                                    ])

    init() {}
}

@available(macOS 12.0, *)
extension Git {
    struct GetTree: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The tree SHA")
        var treeSHA: String

        @Flag(help: "Fetch tree recursively")
        var recursive: Bool = false

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.tree(owner: owner, repository: repository, treeSHA: treeSHA, recursive: recursive)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetRefs: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "Optional ref prefix to filter (e.g. heads, tags)")
        var ref: String?

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.listRefs(owner: owner, repository: repository, ref: ref)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
