//
//  File 2.swift
//
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct Status: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Operate on Status",
                                                           subcommands: [
                                                               GetList.self
                                                           ])

    init() {}
}

@available(macOS 12.0, *)
extension Status {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The SHA, branch name or tag name")
        var reference: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = Octokit(session: session)
            _ = try await octokit.listCommitStatuses(owner: owner, repository: repository, ref: reference)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
