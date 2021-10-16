//
//  IssueView.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI
import OctoKit

struct IssueView: View {
    @StateObject var viewModel: IssueViewModel

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    header
                    Text(viewModel.issue.title ?? "–")
                        .font(.headline)
                    Text(viewModel.issue.body ?? "–")
                        .font(.body)
                }
            }
            .textCase(nil)
            Section(header: Text("Comments")) {
                ForEach(viewModel.comments, id: \.self) { comment in
                    CommentRow(comment: comment)
                }
            }
            .textCase(nil)
        }
        .task {
            await viewModel.loadComments()
        }
        .navigationTitle("#\(viewModel.issue.number)")
    }

    private var header: some View {
        HStack {
            Text("Created by \(viewModel.issue.user?.login ?? "Anonymous")")
                .font(.footnote)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Spacer()
            Text(RelativeDateTimeFormatter().string(for: viewModel.issue.createdAt) ?? "")
                .font(.footnote)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}
