import Foundation

struct Time {

    /**
        A date formatter for RFC 3339 style timestamps. Uses POSIX locale and GMT timezone so that date values are parsed as absolutes.
        - [https://tools.ietf.org/html/rfc3339](https://tools.ietf.org/html/rfc3339)
        - [https://developer.apple.com/library/mac/qa/qa1480/_index.html](https://developer.apple.com/library/mac/qa/qa1480/_index.html)
        - [https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html)
    */
    private static var rfc3339DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        formatter.locale = Locale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(forSecondsFromGMT: 0)
        return formatter
    }()

    /**
        Parses RFC 3339 date strings into NSDate
        - parameter string: The string representation of the date
        - returns: An `NSDate` with a successful parse, otherwise `nil`
     */
    static func rfc3339Date(_ string: String?) -> Date? {
        guard let string = string else { return nil }
        return Time.rfc3339DateFormatter.date(from: string)
    }
}
