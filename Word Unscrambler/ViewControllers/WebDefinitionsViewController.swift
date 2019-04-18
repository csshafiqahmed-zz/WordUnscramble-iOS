import UIKit
import SnapKit
import GoogleMobileAds

class WebDefinitionsViewController: UIViewController {

    // MARK: UIElements
    private var collectionView: UICollectionView!
//    private var adBannerView: GADBannerView!

    // MARK: Attributes
    public var word: String = "Word"
    private var firebaseEvents: FirebaseEvents!
    private var elements = [WebDefinitions?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        firebaseEvents = FirebaseEvents()

        for i in stride(from: 0, to: WebDefinitions.values.count, by: 1) {
            elements.append(WebDefinitions.values[i])
            if (i != 0) && (i % 2 == 1) {
                elements.append(nil)
            }
        }

        setupNavigationBar()
        setupView()
        addConstraints()

        //
//        adBannerView.load(GADRequest())
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
        return elements.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element: WebDefinitions? = elements[indexPath.row]

        if element == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as? BannerAdCollectionViewCell ?? BannerAdCollectionViewCell()
            cell.bannerAd.rootViewController = self
            cell.bannerAd.load(GADRequest())
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WebDefinitionCollectionViewCell ?? WebDefinitionCollectionViewCell()
        cell.refreshView(webDefinition: element!, word: word)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.90, height: collectionView.frame.height - 16)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WebDefinitionCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(BannerAdCollectionViewCell.self, forCellWithReuseIdentifier: "adCell")
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        view.addSubview(collectionView)

//        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        adBannerView.adUnitID = Default.ADMOB_AD_UNIT_ID
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//        view.addSubview(adBannerView)
    }

    override func addConstraints() {
//        adBannerView.snp.makeConstraints { maker in
//            maker.left.right.bottom.equalToSuperview()
//            maker.height.equalTo(64)
//        }

        collectionView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }
    }
}
