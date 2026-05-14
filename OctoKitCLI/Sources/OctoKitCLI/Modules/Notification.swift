//
//  Notification.swift
//

import ArgumentParser
import Foundation
import OctoKit
import Rainbow

@available(macOS 12.0, *)
struct Notification: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Operate on Notifications",
                                                    subcommands: [
                                                        GetList.self,
                                                        GetThread.self
                                                    ])

    init() {}
}

@available(macOS 12.0, *)
extension Notification {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.myNotifications()
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }

    struct GetThread: AsyncParsableCommand {
        @Argument(help: "The ID of the notification thread")
        var threadId: String

        @Argument(help: "The path to put the file in")
        var filePath: String?

        @Flag(help: "Verbose output flag")
        var verbose: Bool = false

        init() {}

        mutating func run() async throws {
            let session = JSONInterceptingURLSession()
            let octokit = makeOctokit(session: session)
            _ = try await octokit.getNotificationThread(threadId: threadId)
            session.verbosePrint(verbose: verbose)
            try session.printResponseToFileOrConsole(filePath: filePath)
        }
    }
}
