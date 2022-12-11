//
//  File.swift
//  
//
//  Created by Piet Brauer-Kallenberg on 11.12.22.
//

import Foundation

extension String {
    var prettyPrintedJSONString: String? {
        guard let dataValue = data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: dataValue),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}
