//
//  RepositoryView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct RepositoryView: View {
    @StateObject var viewModel = RepositoryViewModel()

    var body: some View {
        VStack {
            if let repository = viewModel.currentRepository {
                tabBar(repository: repository)
            } else {
                NavigationView {
                    Text("Please select a Repository")
                        .font(.headline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                repositorySwitcherButton
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $viewModel.showRepositoryChooser) {
            NavigationView {
                RepositoriesView()
                    .onRepositorySelection { repository in
                        viewModel.currentRepository = repository
                    }
            }
        }
    }

    private var repositorySwitcherButton: some View {
        Button {
            viewModel.currentRepository = nil
        } label: {
            Image(systemName: "square.3.stack.3d.middle.filled")
        }
    }

    private func tabBar(repository: Repository) -> some View {
        TabView {
            NavigationView {
                PullRequestsView(viewModel: PullRequestsViewModel(repository: repository))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            repositorySwitcherButton
                        }
                    }
            }
            .tabItem {
                Image(systemName: "shuffle")
                Text("PullRequests")
            }
            NavigationView {
                IssuesView(viewModel: IssuesViewModel(repository: repository))
            }
            .tabItem {
                Image(systemName: "exclamationmark.triangle")
                Text("Issues")
            }
            NavigationView {
                ReleasesView(viewModel: ReleasesViewModel(repository: repository))
            }
            .tabItem {
                Image(systemName: "shippingbox")
                Text("Releases")
            }
        }
    }
}

//struct RepositoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        RepositoryView(repository: Repository(from: ))
//    }
//}
