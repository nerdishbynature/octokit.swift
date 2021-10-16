//
//  ReleasesView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI

struct ReleasesView: View {
    @StateObject var viewModel: ReleasesViewModel

    var body: some View {
        NetworkList(viewModel, error: $viewModel.error, searchText: $viewModel.searchText) {
            ReleasesRow(release: $0)
        }
        .navigationTitle("Releases")
    }
}
