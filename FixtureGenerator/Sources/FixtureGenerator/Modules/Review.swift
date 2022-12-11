//
//  File.swift
//  
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import ArgumentParser
import Foundation
import Rainbow
import OctoKit

@available(macOS 12.0, *)
struct Review: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Reviews",
        subcommands: [
            GetList.self
        ]
    )

    init() {}
}

@available(macOS 12.0, *)
extension Review {
    struct GetList: AsyncParsableCommand {
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
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.reviews(session, owner: owner, repository: repository, pullRequestNumber: number)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}

