//
//  CommentRow.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI
import OctoKit

struct CommentRow: View {
    var comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Created by \(comment.user.login ?? "Anonymous")")
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                Spacer()
                Text(RelativeDateTimeFormatter().string(for: comment.createdAt) ?? "")
                    .font(.footnote)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Text(comment.body)
                .font(.body)
            if let reactions = comment.reactions {
                ReactionView(reactions: reactions)
            }
        }
    }
}
