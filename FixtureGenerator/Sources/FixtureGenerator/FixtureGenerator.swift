import ArgumentParser
import Foundation

@main
@available(macOS 12.0, *)
public struct FixtureGenerator: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A command-line tool to generate stubs",
        subcommands: [
            Issue.self,
            Repository.self,
            Follower.self,
            Label.self,
            Gist.self,
            SortedJSONKeys.self,
            GenerateAllFixtures.self
        ]
    )

    public init() {}
}
