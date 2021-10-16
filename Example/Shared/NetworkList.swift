//
//  NetworkList.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI

struct NetworkList<Data, ID, Content>: View where Data : RandomAccessCollection, Data.Element : Identifiable, ID == Data.Element.ID, Content: View {
    @Binding var error: NSError?
    var isLoading: Bool = false
    var items: Data
    var load: (() async -> Void)
    var rowContent: (Data.Element) -> Content

    init(_ items: Data, error: Binding<NSError?>,isLoading: Bool, load: @escaping (() async -> Void), @ViewBuilder content: @escaping ((Data.Element) -> Content)) {
        self.items = items
        self.isLoading = isLoading
        self.load = load
        self.rowContent = content
        self._error = error
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
    }
}
