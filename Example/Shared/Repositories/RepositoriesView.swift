//
//  RepositoriesView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct RepositoriesView: View {
    @StateObject var viewModel = RepositoriesViewModel()

    var body: some View {
        NetworkList(viewModel, error: $viewModel.error, searchText: $viewModel.searchText) { repository in
            NavigationLink(destination: RepositoryView(repository: repository)) {
                RepositoryRow(repository: repository)
            }
        }
        .navigationTitle(Text("Repositories"))
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
