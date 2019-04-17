import UIKit
import SnapKit
import GoogleMobileAds

class WebDefinitionsViewController: UIViewController {

    // MARK: UIElements
    private var collectionView: UICollectionView!
    private var adBannerView: GADBannerView!

    // MARK: Attributes
    public var word: String = "Word"
    private var firebaseEvents: FirebaseEvents!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        firebaseEvents = FirebaseEvents()

        setupNavigationBar()
        setupView()
        addConstraints()

        //
        adBannerView.load(GADRequest())
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebDefinitionsViewController: GADBannerViewDelegate {
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

extension WebDefinitionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WebDefinitions.values.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WebDefinitionCollectionViewCell ?? WebDefinitionCollectionViewCell()
        cell.refreshView(webDefinition: WebDefinitions.values[indexPath.row], word: word)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.90, height: collectionView.frame.height - 64)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 32, right: 8)
    }
}

extension WebDefinitionsViewController {
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
        titleLabel.text = word
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WebDefinitionCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)

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

        collectionView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(adBannerView.snp.top)
        }
    }
}
