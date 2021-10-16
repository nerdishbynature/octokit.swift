//
//  ExampleApp.swift
//  Shared
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

final class ExampleAppViewModel: ObservableObject {
    @Published var currentRepository: Repository? {
        didSet {
            showRepositoryChooser = currentRepository == nil
        }
    }
    @Published var showRepositoryChooser: Bool = true

    init(currentRepository: Repository?) {
        self.currentRepository = currentRepository
        self.showRepositoryChooser = currentRepository == nil
    }
}

@main
struct ExampleApp: App {
    @StateObject var viewModel = ExampleAppViewModel(currentRepository: nil)

    var body: some Scene {
        WindowGroup {
            Group {
                if let repository = viewModel.currentRepository {
                    RepositoryView(repository: repository)
                } else {
                    Text("Please select a Repository")
                        .font(.headline)
                }
            }
            .sheet(isPresented: $viewModel.showRepositoryChooser) {
                NavigationView {
                    RepositoriesView()
                        .onRepositorySelection { repository in
                            viewModel.currentRepository = repository
                        }
                }
            }
        }
    }
}
