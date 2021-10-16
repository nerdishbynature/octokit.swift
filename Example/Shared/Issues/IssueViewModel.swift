//
//  IssueViewModel.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation
import OctoKit

@MainActor
final class IssueViewModel: ObservableObject {
    var repository: Repository
    var issue: Issue
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var comments: [Comment] = []

    init(repository: Repository, issue: Issue) {
        self.repository = repository
        self.issue = issue
    }

    func loadComments() async {
        do {
            comments = try await OctoClient.shared.issueComments(owner: repository.owner.login!, repository: repository.name!, number: issue.number)
        } catch {
            self.error = error as NSError
        }
    }
}
