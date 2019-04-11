import UIKit
import SnapKit

protocol WordTableViewCellDelegate {
    func infoButtonAction()
}

class WordTableViewCell: UITableViewCell {

    // MARK: UIElements
    let nameLabel = UILabel()
    let infoButton = UIButton()
    let favoriteButton = UIButton()
    let wordButton = UIButton()

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

        infoButton.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().inset(8)
            maker.width.equalTo(contentView.frame.height * 1.5)
        }

        favoriteButton.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().inset(8)
            maker.width.equalTo(contentView.frame.height * 1.5)
        }
    }

    override func setupView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = Font.AlegreyaSans.medium(with: 16)
        nameLabel.textColor = .app
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)

        infoButton.setImage(Icon.eye_24, for: .normal)
        infoButton.imageView?.tintColor = UIColor.app.withAlphaComponent(0.70)
        contentView.addSubview(infoButton)

        favoriteButton.setImage(Icon.star_outline_24, for: .normal)
        favoriteButton.imageView?.tintColor = UIColor.app.withAlphaComponent(0.7)
        contentView.addSubview(favoriteButton)
    }

    public func toggleFavoriteButton(_ isMarkedFavorite: Bool) {
        let image = isMarkedFavorite ? Icon.star_24 : Icon.star_outline_24
        favoriteButton.setImage(image, for: .normal)
    }
}