import UIKit

public struct Icon {

    /// Get the icon by the file name.
    public static func icon(_ name: String) -> UIImage? {
        return UIImage(named: name, in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }

    public static let close_24 = Icon.icon("round_close_black_24pt")
    public static let search_24 = Icon.icon("round_search_black_24pt")
    public static let sort_24 = Icon.icon("round_sort_black_24pt")
    public static let filter_24 = Icon.icon("ic_filter_24dp")
    public static let support_24 = Icon.icon("ic_gift_outline_24dp")
    public static let setting_24 = Icon.icon("ic_settings")
    public static let arrow_down_24 = Icon.icon("baseline_keyboard_arrow_down_black_24pt")
    public static let eye_24 = Icon.icon("baseline_remove_red_eye_black_24pt")
    public static let star_outline_24 = Icon.icon("baseline_star_border_black_24pt")
    public static let star_24 = Icon.icon("baseline_star_black_24pt")
    public static let volume_24 = Icon.icon("baseline_volume_up_black_24pt")
    public static let internet_24 = Icon.icon("baseline_language_black_24pt")
    public static let back_24 = Icon.icon("round_arrow_back_white_24pt")
}