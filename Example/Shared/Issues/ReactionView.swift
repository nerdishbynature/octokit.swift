//
//  ReactionView.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI
import OctoKit

struct ReactionView: View {
    var reactions: Reactions

    var body: some View {
        if reactions.totalCount ?? 0 > 0 {
            HStack(spacing: 5) {
                if let reaction = reactions.thumbsUp, reaction > 0 {
                    singleReaction(count: reaction, emoji: "👍")
                }
                if let reaction = reactions.thumbsDown, reaction > 0 {
                    singleReaction(count: reaction, emoji: "👎")
                }
                if let reaction = reactions.laugh, reaction > 0 {
                    singleReaction(count: reaction, emoji: "😀")
                }
                if let reaction = reactions.hooray, reaction > 0 {
                    singleReaction(count: reaction, emoji: "🎉")
                }
                if let reaction = reactions.confused, reaction > 0 {
                    singleReaction(count: reaction, emoji: "😕")
                }
                if let reaction = reactions.heart, reaction > 0 {
                    singleReaction(count: reaction, emoji: "❤️")
                }
                if let reaction = reactions.rocket, reaction > 0 {
                    singleReaction(count: reaction, emoji: "🚀")
                }
                if let reaction = reactions.eyes, reaction > 0 {
                    singleReaction(count: reaction, emoji: "👀")
                }
            }
        }
    }

    private func singleReaction(count: Int, emoji: String) -> some View {
        HStack {
            Text(String(count))
                .font(.caption)
            Text(emoji)
                .font(.caption)
        }
    }
}
