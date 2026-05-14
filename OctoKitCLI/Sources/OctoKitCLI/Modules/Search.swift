//
//  Search.swift
//

import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct Search: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Search GitHub",
                                                    subcommands: [
                                                        Code.self
                                                    ])

    init() {}
}

@available(macOS 12.0, *)
extension Search {
    struct Code: AsyncParsableCommand {
        @Argument(help: "The search query")
        var query: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.searchCode(query: query)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
