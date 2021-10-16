//
//  RepositoriesViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import Foundation
import OctoKit
import SwiftUI

@MainActor
final class RepositoriesViewModel: ObservableObject, NetworkListViewModel {
    typealias Items = [Repository]

    private var allItems: [Repository] = [] {
        didSet {
            items = allItems
        }
    }
    @Published var items: [Repository] = []
    @Published var error: NSError?
    @Published var isLoading: Bool = false
    @Published var searchText: String {
        didSet {
            if searchText.isEmpty {
                items = allItems
            } else {
                items = allItems.filter {
                    $0.fullName?.lowercased().contains(searchText.lowercased()) ?? false ||
                    $0.repositoryDescription?.lowercased().contains(searchText.lowercased()) ?? false
                }
            }
        }
    }
    var emptyText = "No repositories found"

    init(items: [Repository] = [], isLoading: Bool = false) {
        self.allItems = items
        self.isLoading = isLoading
        self.searchText = ""
        self.error = nil
    }

    func load() async {
        isLoading = true
        do {
            allItems = try await OctoClient.shared.repositories(owner: "nerdishbynature")
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
}

