//
//  NetworkList.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI

struct NetworkList<Data, ID, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, ID == Data.Element.ID, Content: View {
    @Binding var error: NSError?
    var isLoading: Bool = false
    var items: Data
    var load: (() async -> Void)
    var rowContent: (Data.Element) -> Content
    @Binding var searchText: String

    init(_ items: Data, error: Binding<NSError?>, isLoading: Bool, searchText: Binding<String>, load: @escaping (() async -> Void), @ViewBuilder content: @escaping ((Data.Element) -> Content)) {
        self.items = items
        self.isLoading = isLoading
        self.load = load
        self.rowContent = content
        self._error = error
        self._searchText = searchText
    }

    var body: some View {
        ZStack {
            List {
                ForEach(items, id: \.id, content: rowContent)
            }
            if isLoading {
                ProgressView()
            }
        }
        .alert(item: $error) { error in
            Alert(title: Text("An error occured"),
                  message: Text(error.localizedDescription),
                  dismissButton: .cancel())
        }
        .task {
            await load()
        }
        .refreshable {
            await load()
        }
        .searchable(text: $searchText)
        .disableAutocorrection(true)
    }
}

@MainActor
extension NetworkList {
    init<VM: NetworkListViewModel>(_ viewModel: VM, error: Binding<NSError?>, searchText: Binding<String>, @ViewBuilder content: @escaping ((Data.Element) -> Content)) where VM.Items == Data {
        self.items = viewModel.items
        self.isLoading = viewModel.isLoading
        self.load = viewModel.load
        self.rowContent = content
        self._error = error
        self._searchText = searchText
    }
}
