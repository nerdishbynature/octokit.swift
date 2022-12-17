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
struct Star: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Operate on Stars",
                                                           subcommands: [
                                                               GetList.self
                                                           ])

    init() {}
}

@available(macOS 12.0, *)
extension Star {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The user to fetch stars for")
        var name: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = JSONInterceptingURLSession()
            _ = try await octokit.stars(session, name: name)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
