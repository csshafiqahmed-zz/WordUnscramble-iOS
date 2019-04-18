import UIKit

public struct Image {

    /// Get the icon by the file name.
    public static func image(_ name: String) -> UIImage? {
        return UIImage(named: name, in: nil, compatibleWith: nil)
    }

    public static let UNSCRAMBLER_256 = Image.image("unscrambler_256px")
}