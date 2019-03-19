import UIKit
import SnapKit

class WordTableViewCell: UITableViewCell {

    // MARK: UIElements
    let nameLabel = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .greyWhite

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        nameLabel.snp.makeConstraints { maker in
            maker.edges.equalTo(contentView.layoutMarginsGuide.snp.edges)
        }
    }

    override func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = Font.AlegreyaSans.medium(with: 16)
        nameLabel.textColor = .app
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
    }
}