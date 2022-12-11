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
struct Gist: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Gists",
        subcommands: [Get.self]
    )

    init() {}
}

@available(macOS 12.0, *)
extension Gist {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The id of the gist")
        private var id: String

        @Argument(help: "The path to put the file in")
        private var filePath: String

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.gist(session, id: id)
            if let response = session.response, let prettyPrinted = response.prettyPrintedJSONString {
                try prettyPrinted.write(toFile: filePath, atomically: true, encoding: .utf8)
                print("Put file to \(filePath)".green)
            } else {
                print("Received no response.".red)
            }
        }
    }
}
