//
//  ReleasesRow.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI
import OctoKit

struct ReleasesRow: View {
    var release: Release

    var body: some View {
        VStack(alignment: .leading) {
            Text(release.name)
                .font(.headline)
            Text(release.tagName)
                .font(.subheadline)
        }
    }
}
