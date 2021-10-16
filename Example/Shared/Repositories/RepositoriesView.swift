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
        NetworkList(viewModel.repositories,
                    error: $viewModel.error,
                    isLoading: viewModel.isLoading,
                    load: viewModel.load) {
            RepositoryRow(repository: $0)
        }
        .navigationTitle(Text("Repositories"))
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
