//
//  RepositoryView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct RepositoryView: View {
    @State var repository: Repository

    var body: some View {
        TabView {
            NavigationView {
                PullRequestsView(viewModel: PullRequestsViewModel(repository: repository))
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
