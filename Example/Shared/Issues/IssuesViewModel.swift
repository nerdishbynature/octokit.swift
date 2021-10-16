//
//  IssuesViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation
import OctoKit
import SwiftUI

@MainActor
final class IssuesViewModel: ObservableObject, NetworkListViewModel {
    typealias Items = [Issue]
    private var allItems: [Issue] = [] {
        didSet {
            items = allItems
        }
    }
    var repository: Repository
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var items: [Issue] = []
    @Published var searchText: String {
        didSet {
            if searchText.isEmpty {
                items = allItems
            } else {
                items = allItems.filter {
                    $0.title?.lowercased().contains(searchText.lowercased()) ?? false ||
                    String($0.number).contains(searchText)
                }
            }
        }
    }
    var emptyText = "No pull requests found"

    init(repository: Repository, isLoading: Bool = false, items: [Issue] = []) {
        self.repository = repository
        self.isLoading = isLoading
        self.searchText = ""
        self.error = nil
        self.items = items
    }

    func load() async {
        isLoading = true
        do {
            allItems = try await OctoClient.shared.issues(owner: repository.owner.login ?? "", repository: repository.name ?? "")
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
}

