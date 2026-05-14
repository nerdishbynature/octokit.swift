//
//  Repository.swift
//
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct Repository: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Operate on Repositories",
                                                    subcommands: [
                                                        Get.self,
                                                        GetList.self,
                                                        GetTopics.self,
                                                        GetContent.self,
                                                        GetTags.self
                                                    ])

    init() {}
}

@available(macOS 12.0, *)
extension Repository {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var name: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.repository(owner: owner, name: name)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.repositories(owner: owner)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetTopics: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var name: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.repositoryTopics(owner: owner, name: name)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetTags: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var name: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = Octokit(session: session)
            _ = try await octokit.tags(owner: owner, name: name)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetContent: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var name: String

        @Argument(help: "The path within the repository")
        var path: String?

        @Option(name: .long, help: "The branch, tag, or commit ref")
        var ref: String?

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.repositoryContent(owner: owner, name: name, path: path, ref: ref)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
