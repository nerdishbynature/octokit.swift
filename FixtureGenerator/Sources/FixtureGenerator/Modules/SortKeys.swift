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
struct SortedJSONKeys: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Sorting Keys in JSON")

    @Argument(help: "The file path to sort the JSON Content")
    var filePaths: [String]

    init() {}

    mutating func run() async throws {
        for filePath in filePaths {
            let content = try String(contentsOfFile: filePath)
            let prettyString = content.prettyPrintedJSONString
            try prettyString?.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Formatted \(filePath)".green)
        }
    }
}
