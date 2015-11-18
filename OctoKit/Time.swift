//
//  Time.swift
//  OctoKit
//
//  Created by Ben Chatelain on 11/18/15.
//  Copyright © 2015 nerdish by nature. All rights reserved.
//

import Foundation

struct Time {

    /// A date formatter for RFC 3339 style timestamps. Uses POSIX locale and GMT timezone so that date
    /// values are parsed as absolutes.
    /// - https://tools.ietf.org/html/rfc3339
    /// - https://developer.apple.com/library/mac/qa/qa1480/_index.html
    /// - https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html
    private static var rfc3339DateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return formatter
    }()

    static func rfc3339Date(string: String?) -> NSDate? {
        guard let string = string else { return nil }
        return Time.rfc3339DateFormatter.dateFromString(string)
    }

}
