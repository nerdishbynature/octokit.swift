//
//  RepositoriesViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import Foundation
import OctoKit

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var error: NSError?
    @Published var isLoading: Bool = false

    init(repositories: [Repository] = [], error: NSError? = nil, isLoading: Bool = false) {
        self.repositories = repositories
        self.error = error
        self.isLoading = isLoading
    }

    func load() async {
        isLoading = true
        do {
            repositories = try await OctoClient.shared.repositories(owner: "nerdishbynature")
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
}

