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
struct User: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Operate on Users",
                                                           subcommands: [
                                                               Get.self
                                                           ])

    init() {}
}

@available(macOS 12.0, *)
extension User {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The name of the user")
        var name: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = Octokit(session: session)
            _ = try await octokit.user(name: name)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
