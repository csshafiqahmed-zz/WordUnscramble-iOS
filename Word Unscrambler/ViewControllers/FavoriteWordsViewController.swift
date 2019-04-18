import UIKit
import SnapKit
import GoogleMobileAds

class FavoriteWordsViewController: UIViewController {

    // MARK: UIElements
    private var tableView: UITableView!
    private var adBannerView: GADBannerView!

    // MARK: Attributes
    private var staredWordsController: StaredWordsController!
    private let rowHeight: CGFloat = 40.0
    private var words = [Word]()
    private var firebaseEvents: FirebaseEvents!


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        staredWordsController = StaredWordsController.getInstance()
        words = staredWordsController.getListOfWordObjects()
        firebaseEvents = FirebaseEvents()

        setupView()
        setupNavigationBar()
        addConstraints()

        // Load banner ad
        adBannerView.load(GADRequest())
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func cellInfoButtonAction(_ button: UIButton) {
        if let row = Int(button.accessibilityIdentifier!) {
            let word = words[row]
            let viewController = DefinitionViewController()
            viewController.word = word
            viewController.delegate = self
            viewController.providesPresentationContextTransitionStyle = true
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            navigationController?.present(viewController, animated: true)
            firebaseEvents.logDefinitionClick()

            viewController.onDoneBlock = {
                self.words = self.staredWordsController.getListOfWordObjects()
                self.tableView.reloadData()
            }
        }
    }

    @objc private func cellFavoriteButtonAction(_ button: UIButton) {
        if let row = Int(button.accessibilityIdentifier!) {
            let word = words[row]
            if staredWordsController.isWordStared(word.word) {
                staredWordsController.removeWord(word.word)
                words.remove(at: row)
            } else {
                staredWordsController.addWord(word.word)
            }
            tableView.reloadData()
        }
    }
    
    @objc private func cellMoreDefinitionsButtonAction(_ button: UIButton) {
        if let row = Int(button.accessibilityIdentifier!) {
            let word = words[row]
            let viewController = WebDefinitionsViewController()
            viewController.word = word.word
            navigationController?.pushViewController(viewController, animated: true)
            firebaseEvents.logWebDefinitionsClick()
        }
    }
}

extension FavoriteWordsViewController: DefinitionViewControllerDelegate {
    func presentWebDefinitionsForWord(_ word: String) {
        let viewController = WebDefinitionsViewController()
        viewController.word = word
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FavoriteWordsViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        firebaseEvents.logAdLoaded()
    }

    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        firebaseEvents.logAdFailedToLoad()
    }

    public func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        firebaseEvents.logAdClick()
    }

    public func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        firebaseEvents.logAdClick()
    }
}

extension FavoriteWordsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WordTableViewCell ?? WordTableViewCell(style: .default, reuseIdentifier: "cell")

        let word = words[indexPath.row]
        let identifier = "\(indexPath.row)"

        cell.nameLabel.text = word.word
        cell.infoButton.isHidden = !word.definitionExists
        cell.infoButton.addTarget(self, action: #selector(cellInfoButtonAction(_:)), for: .touchUpInside)
        cell.infoButton.accessibilityIdentifier = identifier

        cell.favoriteButton.addTarget(self, action: #selector(cellFavoriteButtonAction(_:)), for: .touchUpInside)
        cell.favoriteButton.accessibilityIdentifier = identifier
        cell.favoriteButton.isHidden = word.definitionExists
        cell.toggleFavoriteButton(staredWordsController.isWordStared(word.word))

        cell.moreDefinitionsButton.isHidden = word.definitionExists
        cell.moreDefinitionsButton.addTarget(self, action: #selector(cellMoreDefinitionsButtonAction(_:)), for: .touchUpInside)
        cell.moreDefinitionsButton.accessibilityIdentifier = identifier

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            staredWordsController.removeWord(words[indexPath.row].word)
            words.remove(at: indexPath.row)
            tableView.reloadData()
            firebaseEvents.logRemovedWordFromFavorite()
        }
    }
}

extension FavoriteWordsViewController {
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
        titleLabel.text = Message.STARED
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
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 4
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = Default.ADMOB_AD_UNIT_ID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        view.addSubview(adBannerView)
    }

    override func addConstraints() {
        adBannerView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(64)
        }

        tableView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(adBannerView.snp.top).inset(-4)
        }
    }
}
