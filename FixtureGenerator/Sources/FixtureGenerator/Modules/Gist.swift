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
        subcommands: [
            Get.self,
            GetList.self
        ]
    )

    init() {}
}

@available(macOS 12.0, *)
extension Gist {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The id of the gist")
        var id: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.gist(session, id: id)
            if let response = session.response, let prettyPrinted = response.prettyPrintedJSONString {
                if let filePath {
                    try prettyPrinted.write(toFile: filePath, atomically: true, encoding: .utf8)
                    print("Put file to \(filePath)".green)
                } else {
                    print(prettyPrinted.blue)
                }
            } else {
                print("Received no response.".red)
            }
        }
    }
}

@available(macOS 12.0, *)
extension Gist {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The id of the gist")
        var owner: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        init() {}

        mutating func run() async throws {
            let octokit = Octokit()
            let session = FixtureURLSession()
            _ = try await octokit.gists(session, owner: owner)
            if let response = session.response, let prettyPrinted = response.prettyPrintedJSONString {
                if let filePath {
                    try prettyPrinted.write(toFile: filePath, atomically: true, encoding: .utf8)
                    print("Put file to \(filePath)".green)
                } else {
                    print(prettyPrinted.blue)
                }
            } else {
                print("Received no response.".red)
            }
        }
    }
}
