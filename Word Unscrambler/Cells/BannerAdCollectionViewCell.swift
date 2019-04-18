import UIKit
import SnapKit
import GoogleMobileAds

class BannerAdCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    private var cardView: UIView!
    internal var bannerAd: GADBannerView!
    private var infoBar: UIView!
    private var title: UILabel!

    // MARK: Attributes
    private var firebaseEvents: FirebaseEvents!

    override init(frame: CGRect) {
        super.init(frame: frame)

        firebaseEvents = FirebaseEvents()
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
            maker.top.equalToSuperview().offset(24)
            maker.bottom.equalToSuperview().inset(16)
        }

        infoBar.snp.makeConstraints { maker in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(52)
        }

        title.snp.makeConstraints { maker in
            maker.top.bottom.left.right.equalToSuperview()
        }

        bannerAd.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(infoBar.snp.bottom)
        }
    }

    override func setupView() {
        cardView = UIView()
        cardView.backgroundColor = .white
        cardView.addShadow(cornerRadius: 4)
        addSubview(cardView)

        bannerAd = GADBannerView(adSize: kGADAdSizeBanner)
        bannerAd.adUnitID = Default.ADMOB_AD_UNIT_ID
        bannerAd.delegate = self
        cardView.addSubview(bannerAd)

        infoBar = UIView()
        infoBar.backgroundColor = .app
        infoBar.addShadow(cornerRadius: 0)
        cardView.addSubview(infoBar)

        title = UILabel()
        title.text = "Sponsored"
        title.textColor = .white
        title.textAlignment = .center
        title.font = Font.AlegreyaSans.medium(with: 22)
        infoBar.addSubview(title)
    }
}

extension BannerAdCollectionViewCell: GADBannerViewDelegate {
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