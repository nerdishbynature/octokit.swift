//
//  NSError+Identifiable.swift
//  Example
//
//  Created by Piet Brauer-Kallenberg on 06.10.21.
//

import Foundation

extension NSError: Identifiable {
    public var id: String {
        String(code)
    }
}
