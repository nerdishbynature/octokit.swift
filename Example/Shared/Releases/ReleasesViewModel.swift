//
//  ReleasesViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation
import OctoKit
import SwiftUI

@MainActor
final class ReleasesViewModel: ObservableObject, NetworkListViewModel {
    typealias Items = [Release]
    private var allItems: Items = [] {
        didSet {
            items = allItems
        }
    }
    var repository: Repository
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var items: Items = []
    @Published var searchText: String {
        didSet {
            if searchText.isEmpty {
                items = allItems
            } else {
                items = allItems.filter {
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.tagName.lowercased().contains(searchText)
                }
            }
        }
    }
    var emptyText = "No pull requests found"

    init(repository: Repository, isLoading: Bool = false, items: Items = []) {
        self.repository = repository
        self.isLoading = isLoading
        self.searchText = ""
        self.error = nil
        self.items = items
    }

    func load() async {
        isLoading = true
        do {
            allItems = try await OctoClient.shared.listReleases(owner: repository.owner.login ?? "", repository: repository.name ?? "")
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
}
