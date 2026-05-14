//
//  File.swift
//
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct PullRequest: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Operate on PullRequest",
                                                           subcommands: [
                                                               Get.self,
                                                               GetList.self
                                                           ])

    init() {}
}

@available(macOS 12.0, *)
extension PullRequest {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The number of the pull request")
        var number: Int

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = Octokit(session: session)
            _ = try await octokit.pullRequest(owner: owner, repository: repository, number: number)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Option(help: "Filter by state: open, closed, all")
        var state: String = "open"

        @Option(help: "Number of results per page")
        var perPage: String = "30"

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let openness = Openness(rawValue: state) ?? .open
            let session = JSONInterceptingURLSession()
            let octokit = Octokit(session: session)
            _ = try await octokit.pullRequests(owner: owner, repository: repository, state: openness, perPage: perPage)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
