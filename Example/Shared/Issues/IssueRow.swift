//
//  IssueRow.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI
import OctoKit

struct IssueRow: View {
    var issue: Issue

    var body: some View {
        VStack(alignment: .leading) {
            Text(issue.title ?? "No title")
                .font(.headline)
            Text("#\(issue.number)")
                .font(.subheadline)
        }
    }
}
