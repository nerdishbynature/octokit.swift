//
//  NetworkListViewModel.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 16.10.21.
//

import Foundation

@MainActor
protocol NetworkListViewModel: ObservableObject {
    associatedtype Items: RandomAccessCollection

    var items: Items { get set }
    var isLoading: Bool { get set }
    var emptyText: String { get }

    func load() async
}
