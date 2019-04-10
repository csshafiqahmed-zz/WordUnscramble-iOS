import UIKit

public class Circle: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupView() {
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8))
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.path = circle.cgPath
        circleShapeLayer.fillColor = UIColor.black.cgColor
        circleShapeLayer.position = CGPoint.zero
        self.layer.addSublayer(circleShapeLayer)
    }
}