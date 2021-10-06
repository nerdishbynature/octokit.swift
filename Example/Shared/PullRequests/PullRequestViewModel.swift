//
//  PullRequestViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import Foundation
import OctoKit

@MainActor
final class PullRequestsViewModel: ObservableObject {
    var repository: Repository
    @Published var isLoading: Bool = false
    @Published var error: NSError? = nil
    @Published var pullRequests: [PullRequest] = []

    init(repository: Repository, isLoading: Bool = false, error: NSError? = nil, pullRequests: [PullRequest] = []) {
        self.repository = repository
        self.isLoading = isLoading
        self.error = error
        self.pullRequests = pullRequests
    }

    func load() async {
        isLoading = true
        do {
            pullRequests = try await OctoClient.shared.pullRequests(owner: repository.owner.login ?? "", repository: repository.name ?? "")
        } catch {
            self.error = error as NSError
        }
        isLoading = false
    }
}
