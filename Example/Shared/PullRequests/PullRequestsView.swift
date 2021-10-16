//
//  PullRequestsView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct PullRequestsView: View {
    @StateObject var viewModel: PullRequestsViewModel

    var body: some View {
        NetworkList(viewModel, error: $viewModel.error, searchText: $viewModel.searchText) { 
            PullRequestRow(pullRequest: $0)
        }
        .navigationTitle("Pull Requests")
    }
}
