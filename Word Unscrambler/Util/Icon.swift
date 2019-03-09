import UIKit

public struct Icon {

    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }

    public static let close_24 = Icon.icon("round_close_black_24pt")
    public static let search_24 = Icon.icon("round_search_black_24pt")
}