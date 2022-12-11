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
struct Gist: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Operate on Gists",
                                                           subcommands: [
                                                               Get.self,
                                                               GetList.self
                                                           ])

    init() {}
}

@available(macOS 12.0, *)
extension Gist {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The id of the gist")
        var id: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.gist(session, id: id)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}

@available(macOS 12.0, *)
extension Gist {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the gists")
        var owner: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.gists(session, owner: owner)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
