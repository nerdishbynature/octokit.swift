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
        ZStack {
            List {
                ForEach(viewModel.repositories, id: \.id) {
                    RepositoryRow(repository: $0)
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("An error occured"),
                  message: Text(error.localizedDescription),
                  dismissButton: .cancel())
        }
        .navigationTitle(Text("Repositories"))
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
    }
}

extension NSError: Identifiable {
    public var id: String {
        String(code)
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
