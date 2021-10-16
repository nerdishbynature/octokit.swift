//
//  PullRequestRow.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct PullRequestRow: View {
    var pullRequest: PullRequest

    var body: some View {
        VStack(alignment: .leading) {
            Text(pullRequest.title ?? "No title")
                .font(.headline)
            Text("#\(pullRequest.number)")
                .font(.subheadline)
        }
    }
}
