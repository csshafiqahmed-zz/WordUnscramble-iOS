import UIKit

public struct Font {

    // Alegreya
    public struct AlegreyaSans {

        public static func regular(with size: CGFloat) -> UIFont {
            if let font = UIFont(name: "AlegreyaSans-Regular", size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }

        public static func medium(with size: CGFloat) -> UIFont {
            if let font = UIFont(name: "AlegreyaSans-Medium", size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }

        public static func bold(with size: CGFloat) -> UIFont {
            if let font = UIFont(name: "AlegreyaSans-Bold", size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }

        public static func extraBold(with size: CGFloat) -> UIFont {
            if let font = UIFont(name: "AlegreyaSans-ExtraBold", size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }

        public static func black(with size: CGFloat) -> UIFont {
            if let font = UIFont(name: "AlegreyaSans-Black", size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size)
        }
    }
}