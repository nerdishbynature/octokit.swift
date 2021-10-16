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
        NetworkList<Repository, RepositoryRow>(error: $viewModel.error,
                                               isLoading: viewModel.isLoading,
                                               items: viewModel.repositories,
                                               load: viewModel.load,
                                               rowContent: { RepositoryRow(repository: $0) })
            .navigationTitle(Text("Repositories"))
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
