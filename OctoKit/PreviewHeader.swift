import Foundation
import RequestKit

/// Some API provide additional data for new (preview) API if a custom header is added to the request.
///
/// - Note: Preview APIs are subject to change.
public enum PreviewHeader {
    /// The `Reactions` preview header provides reactions in `Comment`s.
    case reactions

    var header: HTTPHeader {
        switch self {
        case .reactions:
            return HTTPHeader(headerField: "Accept", value: "application/vnd.github.squirrel-girl-preview")
        }
    }
}



