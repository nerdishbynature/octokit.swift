import ArgumentParser
import Foundation

@main
@available(macOS 12.0, *)
public struct OctokitCLI: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "A command-line tool for GitHub using octokit.swift",
                                                           subcommands: [
                                                               Issue.self,
                                                               Repository.self,
                                                               Follower.self,
                                                               Label.self,
                                                               PullRequest.self,
                                                               Release.self,
                                                               Review.self,
                                                               Star.self,
                                                               Status.self,
                                                               User.self,
                                                               Gist.self,
                                                               SortedJSONKeys.self
                                                           ])

    public init() {}
}
