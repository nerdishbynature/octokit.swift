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
    private var onRepositorySelection: (_ repository: Repository) -> Void

    init(_ onRepositorySelection: @escaping (_ repository: Repository) -> Void) {
        self.onRepositorySelection = onRepositorySelection
    }

    var body: some View {
        NetworkList(viewModel, error: $viewModel.error, searchText: $viewModel.searchText) { repository in
            RepositoryRow(repository: repository)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .clipShape(Rectangle())
                .onTapGesture {
                    onRepositorySelection(repository)
                }
        }
        .navigationTitle(Text("Repositories"))
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView { repository in
            print(repository.name ?? "")
        }
    }
}
