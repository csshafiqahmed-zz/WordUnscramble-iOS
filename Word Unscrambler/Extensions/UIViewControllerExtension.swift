import UIKit

extension UIViewController {

    @objc func addConstraints() {}

    @objc func setupView() {}

    var bottomLayoutMargin: CGFloat {
        return Device.hasNotch ? 39 : 10
    }
}