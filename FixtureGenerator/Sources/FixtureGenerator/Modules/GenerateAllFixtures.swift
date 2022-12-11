//
//  File.swift
//
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import ArgumentParser
import Foundation
import Rainbow

@available(macOS 12.0, *)
struct GenerateAllFixtures: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Generates all fixtures")

    @Argument(help: "The path to put the files in")
    private var directoryPath: String

    init() {}

    mutating func run() async throws {
        var getGist = Gist.Get()
        getGist.id = "6cad326836d38bd3a7ae"
        getGist.filePath = directoryPath.appending("/gist.json")
        try await getGist.run()

        var getGists = Gist.GetList()
        getGists.owner = "octocat"
        getGists.filePath = directoryPath.appending("/gists.json")
        try await getGists.run()
    }
}
