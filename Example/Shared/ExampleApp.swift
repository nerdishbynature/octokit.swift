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
        }
    }
}

@main
struct ExampleApp: App {
    @StateObject var viewModel = ExampleAppViewModel()
    @StateObject var signinViewModel = SinginViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.token != nil {
                    RepositoryView()
                } else {
                    NavigationView {
                        ProgressView()
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
