import UIKit
import SnapKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    // MARK: UIElements
    let titleLabel = UILabel()
    let dividerView = UIView()

    // MARK: Attributes
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
        setupView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let marginGuide = contentView.frame
        if marginGuide.height == 0 || marginGuide.width == 0 {
            return
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(contentView.layoutMarginsGuide.snp.left)
            maker.right.equalTo(contentView.layoutMarginsGuide.snp.right)
            maker.top.equalTo(contentView.layoutMarginsGuide.snp.top)
            maker.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom)
        }

        dividerView.snp.makeConstraints { maker in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
            maker.height.equalTo(1.5)
        }
    }

    override func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Font.AlegreyaSans.medium(with: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        dividerView.backgroundColor = .divider
        contentView.addSubview(dividerView)
    }

    /**
        Tap Gesture method that gets fired when tapped on the header cell.
        Calls delegate method to either show or hide the section
     */
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }

        delegate?.toggleSection(self, section: cell.section)
    }
}
