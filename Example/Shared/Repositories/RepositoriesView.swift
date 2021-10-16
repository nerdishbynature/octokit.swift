//
//  RepositoriesView.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

struct RepositoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = RepositoriesViewModel()
    private var onRepositorySelection: ((_ repository: Repository) -> Void)?

    var body: some View {
        NetworkList(viewModel, error: $viewModel.error, searchText: $viewModel.searchText) { repository in
            RepositoryRow(repository: repository)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .clipShape(Rectangle())
                .onTapGesture {
                    onRepositorySelection?(repository)
                }
        }
        .navigationTitle(Text("Repositories"))
    }

    func onRepositorySelection(_ closure: @escaping (_ repository: Repository) -> Void) -> some View {
        var modifiedSelf = self
        modifiedSelf.onRepositorySelection = closure
        return modifiedSelf
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
