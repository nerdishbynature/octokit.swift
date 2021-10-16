//
//  ExampleApp.swift
//  Shared
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

final class ExampleAppViewModel: ObservableObject {
    @Published var token: String? {
        didSet {
            if let token = token {
                OctoClient.shared = Octokit(TokenConfiguration(token))
            }
            showRepositoryChooser = token != nil && currentRepository == nil
        }
    }
    @Published var currentRepository: Repository? {
        didSet {
            showRepositoryChooser = currentRepository == nil
        }
    }
    @Published var showRepositoryChooser: Bool = false
    @Published var showLogin: Bool = false

    init(currentRepository: Repository?) {
        self.currentRepository = currentRepository
        self.showRepositoryChooser = false
        self.showLogin = token == nil
    }
}

@main
struct ExampleApp: App {
    @StateObject var viewModel = ExampleAppViewModel(currentRepository: nil)
    @StateObject var signinViewModel = SinginViewModel()

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
            .task {
                if viewModel.token == nil {
                    viewModel.token = await signinViewModel.signin()
                }
            }
        }
    }
}
