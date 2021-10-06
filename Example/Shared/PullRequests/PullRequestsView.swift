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
        ZStack {
            List {
                ForEach(viewModel.pullRequests, id: \.id) {
                    PullRequestRow(pullRequest: $0)
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Pull Requests")
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("An error occured"),
                  message: Text(error.localizedDescription),
                  dismissButton: .cancel())
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}

//struct PullRequestsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PullRequestsView(viewModel: PullRequestsViewModel()
//    }
//}
