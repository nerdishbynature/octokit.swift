//
//  NetworkList.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import SwiftUI

struct NetworkList<T: Identifiable, V: View>: View  {
    @Binding var error: NSError?
    var isLoading: Bool = false
    var items: [T] = []
    var load: (() async -> Void)
    var rowContent: (_ item: T) -> V

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
