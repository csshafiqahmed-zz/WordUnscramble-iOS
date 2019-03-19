import UIKit

extension UIView {

    func addShadow(cornerRadius: CGFloat = 2, offset: CGSize = CGSize(width: 0, height: 2), opacity: Float = 0.3,
                   shadowRadius: CGFloat = 2, color: CGColor = UIColor.black.cgColor,
                   corners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = color

        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = corners
        }
    }

    @objc func setupView() {}
}
