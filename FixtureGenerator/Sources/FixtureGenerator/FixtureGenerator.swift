import ArgumentParser
import Foundation

@main
@available(macOS 12.0, *)
public struct FixtureGenerator: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A command-line tool to generate stubs",
        subcommands: [Gist.self, SortedJSONKeys.self]
    )

    public init() {}
}
