import UIKit
import SnapKit

class DefinitionTableViewCell: UITableViewCell {

    // MARK: UIElements
    private let bulletView = Circle()
    let definitionLabel = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let marginGuide = contentView.layoutMarginsGuide

        bulletView.snp.makeConstraints { maker in
            maker.left.equalTo(marginGuide.snp.left).offset(24)
            maker.top.equalTo(marginGuide.snp.top).offset(8.5)
            maker.size.equalTo(8)
        }

        definitionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(marginGuide.snp.top).offset(0)
            maker.bottom.equalTo(marginGuide.snp.bottom).inset(0)
            maker.right.equalTo(marginGuide.snp.right).inset(16)
            maker.left.equalTo(bulletView.snp.right).offset(8)
        }

    }

    override func setupView() {
        contentView.addSubview(bulletView)

        definitionLabel.textColor = .app
        definitionLabel.textAlignment = .left
        definitionLabel.font = Font.AlegreyaSans.medium(with: 20)
        definitionLabel.numberOfLines = 0
        definitionLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(definitionLabel)
    }
}