import UIKit
import SnapKit
import WebKit

class WebDefinitionCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    private var cardView: UIView!
    private var infoBar: UIView!
    public var title: UILabel!
    public var image: UIImageView!
    public var webView: WKWebView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cardView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.top.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().inset(16)
        }

        infoBar.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(52)
        }

        title.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.centerX.equalTo(infoBar.snp.centerX).offset(18)
            maker.width.equalTo(title.intrinsicContentSize.width)
        }

        image.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().inset(4)
            maker.right.equalTo(title.snp.left).offset(-4)
            maker.width.equalTo(32)
        }

        webView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(1)
            maker.right.equalToSuperview().inset(1)
            maker.bottom.equalToSuperview()
            maker.top.equalTo(infoBar.snp.bottom)
        }

    }

    override func setupView() {
        cardView = UIView()
        cardView.backgroundColor = .white
        cardView.addShadow(cornerRadius: 4)
        addSubview(cardView)

        infoBar = UIView()
        infoBar.backgroundColor = .app
        infoBar.addShadow(cornerRadius: 0.25)
        cardView.addSubview(infoBar)

        title = UILabel()
        title.text = "Merriam-Webster"
        title.textColor = .white
        title.textAlignment = .center
        title.font = Font.AlegreyaSans.medium(with: 22)
        infoBar.addSubview(title)

        image = UIImageView()
        image.image = Icon.internet_24
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        infoBar.addSubview(image)

        webView = WKWebView()
        webView.scrollView.bounces = false
        webView.load(URLRequest(url: URL(string: "https://www.google.com")!))
        cardView.addSubview(webView)
    }

    public func refreshView(webDefinition: WebDefinitions, word: String) {
        title.text = webDefinition.title
        image.image = webDefinition.image
        webView.load(URLRequest(url: URL(string: "\(webDefinition.url)\(word)")!))
    }
}