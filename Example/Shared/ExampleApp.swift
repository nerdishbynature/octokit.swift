//
//  ExampleApp.swift
//  Shared
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import SwiftUI
import OctoKit

@main
struct ExampleApp: App {
    @State var currentRepository: Repository?

    var body: some Scene {
        WindowGroup {
            if let repository = currentRepository {
                RepositoryView(repository: repository)
            } else {
                NavigationView {
                    RepositoriesView {
                        currentRepository = $0
                    }
                }
            }
        }
    }
}
