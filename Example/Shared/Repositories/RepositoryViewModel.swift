//
//  RepositoryViewModel.swift
//  Example (iOS)
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation
import OctoKit

final class RepositoryViewModel: ObservableObject {
    @Published var currentRepository: Repository? {
        didSet {
            showRepositoryChooser = currentRepository == nil
        }
    }
    @Published var showRepositoryChooser: Bool = true

    init(currentRepository: Repository? = nil) {
        self.currentRepository = currentRepository
        self.showRepositoryChooser = true
    }
}
