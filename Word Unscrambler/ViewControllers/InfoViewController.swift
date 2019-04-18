import UIKit
import SnapKit
import MessageUI

class InfoViewController: UIViewController {

    // MARK: UIElements
    private var appIconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var versionLabel: UILabel!
    private var shareButton: UIButton!
    private var rateButton: UIButton!
    private var feedbackButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationBar()
        setupView()
        addConstraints()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func shareButtonAction() {
        let message = "Checkout Word Unscrambler!! It helps you unscramble any scrambled english word. https://itunes.apple.com/us/app/word-unscrambler/id1166397295"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }

    @objc private func rateButtonAction() {
        let url = URL(string: "itms-apps://itunes.apple.com/app/id1166397295")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }

    @objc private func feedbackButtonAction() {
        navigationController?.pushViewController(FeedbackViewController(), animated: true)
    }
}

extension InfoViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .app
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.navigationBarShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2

        // Title
        let titleLabel = UILabel()
        titleLabel.text = Message.ABOUT
        titleLabel.font = Font.AlegreyaSans.bold(with: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel

        // Back Button
        let backButton = UIButton(type: .custom)
        backButton.setImage(Icon.back_24, for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    override func setupView() {
        appIconImageView = UIImageView()
        view.addSubview(appIconImageView)

        titleLabel = UILabel()
        titleLabel.text = Message.UNSCRAMBLE
        titleLabel.font = Font.AlegreyaSans.bold(with: 36)
        titleLabel.textColor = .app
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        versionLabel = UILabel()
        versionLabel.text = Default.VERSION
        versionLabel.textColor = .app
        versionLabel.font = Font.AlegreyaSans.regular(with: 24)
        versionLabel.textAlignment = .center
        view.addSubview(versionLabel)

        shareButton = UIButton()
        shareButton.backgroundColor = .app
        shareButton.setTitle("Share App", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 24)
        shareButton.addShadow(cornerRadius: 4)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
        view.addSubview(shareButton)

        rateButton = UIButton()
        rateButton.backgroundColor = .app
        rateButton.setTitle("Rate App", for: .normal)
        rateButton.setTitleColor(.white, for: .normal)
        rateButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 24)
        rateButton.addShadow(cornerRadius: 4)
        rateButton.addTarget(self, action: #selector(rateButtonAction), for: .touchUpInside)
        view.addSubview(rateButton)

        feedbackButton = UIButton()
        feedbackButton.backgroundColor = .app
        feedbackButton.setTitle("Feedback", for: .normal)
        feedbackButton.setTitleColor(.white, for: .normal)
        feedbackButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 24)
        feedbackButton.addShadow(cornerRadius: 4)
        feedbackButton.addTarget(self, action: #selector(feedbackButtonAction), for: .touchUpInside)
        view.addSubview(feedbackButton)

    }

    override func addConstraints() {

        appIconImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(36)
            maker.size.equalTo(64)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(appIconImageView.snp.bottom).offset(24)
            maker.height.equalTo(titleLabel.intrinsicContentSize.height)
        }

        versionLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.height.equalTo(versionLabel.intrinsicContentSize.height)
        }

        shareButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(36)
            maker.right.equalToSuperview().inset(36)
            maker.top.equalTo(versionLabel.snp.bottom).offset(72)
            maker.height.equalTo(48)
        }

        rateButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(36)
            maker.right.equalToSuperview().inset(36)
            maker.top.equalTo(shareButton.snp.bottom).offset(36)
            maker.height.equalTo(48)
        }

        feedbackButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(36)
            maker.right.equalToSuperview().inset(36)
            maker.top.equalTo(rateButton.snp.bottom).offset(36)
            maker.height.equalTo(48)
        }
    }
}