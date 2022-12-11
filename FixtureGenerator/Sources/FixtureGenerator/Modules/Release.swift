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
struct Release: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Releases",
        subcommands: [
//            Get.self,
            GetList.self
        ]
    )

    init() {}
}

@available(macOS 12.0, *)
extension Release {
//    struct Get: AsyncParsableCommand {
//        @Argument(help: "The owner of the repository")
//        var owner: String
//
//        @Argument(help: "The name of the repository")
//        var repository: String
//
//        @Argument(help: "The tag of the release")
//        var tag: String
//
//        @Argument(help: "The path to put the file in")
//        var filePath: String?
//
//        @Flag(help: "Verbose output flag")
//        var verbose: Bool = false
//
//        init() {}
//
//        mutating func run() async throws {
//            let octokit = Octokit()
//            let session = FixtureURLSession()
//            _ = try await octokit.release(session, owner: owner, repository: repository, tag: tag)
//            session.verbosePrint(verbose: verbose)
//            try session.printResponseToFileOrConsole(filePath: filePath)
//        }
//    }

    struct GetList: AsyncParsableCommand {
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
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.listReleases(session, owner: owner, repository: repository)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
