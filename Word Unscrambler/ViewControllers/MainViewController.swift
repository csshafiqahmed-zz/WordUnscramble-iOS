import UIKit
import SnapKit
import FirebaseAuth
import GoogleMobileAds

class MainViewController: UIViewController {

    // MARK: UIElements
    private var textFieldView: UIView!
    private var textField: TextField!
    private var clearTextFieldButton: UIButton!
    private var searchButton: UIButton!
    private var textFieldLine: UIView!
    private var tableView: UITableView!
    private var noResultsLabel: UILabel!
    private var infoLabel: UILabel!
    private var dividerView: UIView!
    private var adBannerView: GADBannerView!
//    private var filterButton: UIButton!

    // MARK: Attributes
    private var firebaseEvents: FirebaseEvents!
    private var unscrambler: UnScrambler!
    private var staredWordsController: StaredWordsController!
    private var data: [TableViewSection] = [TableViewSection]()
    private let rowHeight: CGFloat = 40.0
    private let headerHeight: CGFloat = 44.0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Firebase SignIn using AnonymousSignIn
        Auth.auth().signInAnonymously()

        view.backgroundColor = .white
        unscrambler = UnScrambler.getInstance()
        staredWordsController = StaredWordsController.getInstance()
        firebaseEvents = FirebaseEvents()

        setupView()
        setupNavigationBar()
        addConstraints()
        textFieldDidChange()

        // Hide keyboard tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // Load banner ad
        adBannerView.load(GADRequest())
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // refresh status bar
        setNeedsStatusBarAppearanceUpdate()

        // refresh tableView after topViewController is popped
        if tableView != nil {
            tableView.reloadData()
        }
    }

    /**
        Target method for favorite button in NavigationBar.
        Pushes to FavoriteWordsViewController on click
     */
    @objc private func favoriteButtonAction() {
        navigationController?.pushViewController(FavoriteWordsViewController(), animated: true)
    }

    @objc private func infoButtonAction() {
        navigationController?.pushViewController(InfoViewController(), animated: true)
    }

    /**
        Target method for ClearTextField button in TextField
        Clears TextField text on click and hides button
     */
    @objc private func clearTextFieldButtonAction() {
        textField.text = ""
        textFieldDidChange()
    }

    /**
        Target method for search button in TextField
        On click:
            - dismisses keyboard
            - unscrambles word to find all possible words
            - refreshes UI once data is ready
     */
    @objc private func searchButtonAction() {
        textField.resignFirstResponder()
        data = unscrambler.unscrambleWord(textField.text!)
        tableView.reloadData()
        toggleNoResultsLabel()
        infoLabel.text = getInfoLabel(textField.text!)
        firebaseEvents.logUnscramble()
    }

    /**
        Target method for info button in TableViewCell
        Presents DefinitionViewController for the selected word
     */
    @objc private func cellInfoButtonAction(_ button: UIButton) {
        let array = (button.accessibilityIdentifier?.split(separator: ","))!
        if let section = Int(array[0]), let row = Int(array[1]) {
            let word = data[section].words[row]
            let viewController = DefinitionViewController()
            viewController.word = word
            viewController.delegate = self
            viewController.providesPresentationContextTransitionStyle = true
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            navigationController?.present(viewController, animated: true)
            firebaseEvents.logDefinitionClick()
        }
    }

    /**
        Target method for favorite button in TableViewCell
        Adds word to favorite list if not already, else removes it if already stared
     */
    @objc private func cellFavoriteButtonAction(_ button: UIButton) {
        let array = (button.accessibilityIdentifier?.split(separator: ","))!
        if let section = Int(array[0]), let row = Int(array[1]) {
            let word = data[section].words[row]
            if staredWordsController.isWordStared(word.word) {
                staredWordsController.removeWord(word.word)
            } else {
                staredWordsController.addWord(word.word)
            }
            tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        }
    }

    /**
        Target method for web button in TableViewCell
        Presents WebDefinitionsViewController for the selected word
     */
    @objc private func cellMoreDefinitionsButtonAction(_ button: UIButton) {
        let array = (button.accessibilityIdentifier?.split(separator: ","))!
        if let section = Int(array[0]), let row = Int(array[1]) {
            let word = data[section].words[row]
            let viewController = WebDefinitionsViewController()
            viewController.word = word.word
            navigationController?.pushViewController(viewController, animated: true)
            firebaseEvents.logWebDefinitionsClick()
        }
    }

    /**
        Target method TextField on editingChanged listener
        Toggles clear button to hidden or visible
     */
    @objc private func textFieldDidChange() {
        toggleClearButton()
    }

    /**
        Dismisses keyboard on tap gesture outside of the textField view
     */
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.textFieldView)

        if !textFieldView.frame.contains(location) || searchButton.frame.contains(location) {
            view.endEditing(true)
        }
    }

    /**
        Checks if TextField is empty, if so hide the clear button, else show the button
     */
    private func toggleClearButton() {
        let isEmpty = textField.text == ""
        clearTextFieldButton.isHidden = isEmpty

        clearTextFieldButton.snp.updateConstraints { maker in
            maker.width.equalTo(isEmpty ? 0 : 48)
        }
    }

    /**
        Hides noResultsLabel if no results found for entered word, else show
     */
    private func toggleNoResultsLabel() {
        noResultsLabel.isHidden = data.count > 0
    }

    /**
        Constructs fancy string for infoLabel once word unscrambles
        Format: "{results_count} words found with letters {word}"
     */
    private func getInfoLabel(_ word: String) -> String {
        var totalWords = 0
        data.forEach { section in
            totalWords += section.words.count
        }

        return "\(totalWords) words found with letters '\(word)'"
    }

    /*    @objc private func filterButtonAction() {
        let filterViewController = FilterViewController()
        filterViewController.providesPresentationContextTransitionStyle = true
        filterViewController.definesPresentationContext = true
        filterViewController.modalPresentationStyle = .overFullScreen
        filterViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(filterViewController, animated: true)
    }*/
}

extension MainViewController: GADBannerViewDelegate {
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

extension MainViewController:DefinitionViewControllerDelegate {
    func presentWebDefinitionsForWord(_ word: String) {
        let viewController = WebDefinitionsViewController()
        viewController.word = word
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].collapsed ? 0 : data[section].words.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WordTableViewCell ?? WordTableViewCell(style: .default, reuseIdentifier: "cell")

        let item: Word = data[indexPath.section].words[indexPath.row]
        let identifier = "\(indexPath.section),\(indexPath.row)"

        cell.nameLabel.text = item.word
        cell.infoButton.addTarget(self, action: #selector(cellInfoButtonAction(_:)), for: .touchUpInside)
        cell.infoButton.accessibilityIdentifier = identifier
        cell.infoButton.isHidden = !item.definitionExists

        cell.favoriteButton.addTarget(self, action: #selector(cellFavoriteButtonAction(_:)), for: .touchUpInside)
        cell.favoriteButton.accessibilityIdentifier = identifier
        cell.favoriteButton.isHidden = item.definitionExists
        cell.toggleFavoriteButton(staredWordsController.isWordStared(item.word))

        cell.moreDefinitionsButton.isHidden = item.definitionExists
        cell.moreDefinitionsButton.addTarget(self, action: #selector(cellMoreDefinitionsButtonAction(_:)), for: .touchUpInside)
        cell.moreDefinitionsButton.accessibilityIdentifier = identifier

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")

        header.titleLabel.text = data[section].headerName
        header.section = section
        header.delegate = self
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

extension MainViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchButtonAction()
        return true
    }
}

extension MainViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !data[section].collapsed

        data[section].collapsed = collapsed
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension MainViewController {

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
        titleLabel.text = Message.UNSCRAMBLE
        titleLabel.font = Font.AlegreyaSans.bold(with: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel

        // Info Button
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(Icon.info_24, for: .normal)
        infoButton.imageView?.tintColor = .white
        infoButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)

        // Donate
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(Icon.star_24, for: .normal)
        favoriteButton.imageView?.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16

        // Right bar buttons
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: infoButton), space, UIBarButtonItem(customView: favoriteButton)]
    }

    override func addConstraints() {

        textFieldView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalToSuperview().inset(12)
            maker.top.equalToSuperview().offset(12)
            maker.height.equalTo(52)
        }

        searchButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview()
            maker.top.equalToSuperview().offset(2)
            maker.size.equalTo(48)
        }

        clearTextFieldButton.snp.makeConstraints { maker in
            maker.right.equalTo(searchButton.snp.left).inset(12)
            maker.top.equalToSuperview().offset(2)
            maker.size.equalTo(48)
        }

        textField.snp.makeConstraints { maker in
            maker.left.top.bottom.equalToSuperview()
            maker.right.equalTo(clearTextFieldButton.snp.left)
        }

        textFieldLine.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(8)
            maker.right.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(6)
            maker.height.equalTo(2)
        }

        infoLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().inset(12)
            maker.top.equalTo(textFieldView.snp.bottom).offset(12)
            maker.height.equalTo(24)
        }

        dividerView.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(infoLabel.snp.bottom).offset(6)
            maker.height.equalTo(1)
        }

        adBannerView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(64)
        }

        tableView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalToSuperview().inset(12)
            maker.top.equalTo(dividerView.snp.bottom).offset(12)
            maker.bottom.equalTo(adBannerView.snp.top).inset(-4)
        }

//        filterButton.snp.makeConstraints { maker in
//            maker.right.equalToSuperview().inset(12)
//            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
//            maker.size.equalTo(56)
////            maker.centerX.equalToSuperview()
////            maker.top.bottom.equalToSuperview()
////            maker.width.equalTo(136)
//        }

        noResultsLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(noResultsLabel.intrinsicContentSize.height*2)
            maker.width.equalTo(noResultsLabel.intrinsicContentSize.width)
        }
    }

    override func setupView() {
        textFieldView = UIView()
        textFieldView.backgroundColor = .white
        view.addSubview(textFieldView)

        textField = TextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: Message.TEXT_FIELD_PLACE_HOLDER,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolder])
        textField.font = Font.AlegreyaSans.medium(with: 24)
        textField.textColor = .app
        textField.tintColor = .app
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.returnKeyType = .search
        textField.autocapitalizationType = .none
        textFieldView.addSubview(textField)

        searchButton = UIButton()
        searchButton.backgroundColor = .clear
        searchButton.setImage(Icon.search_24, for: .normal)
        searchButton.imageView?.tintColor = .highlight
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        textFieldView.addSubview(searchButton)

        clearTextFieldButton = UIButton(type: .custom)
        clearTextFieldButton.backgroundColor = .clear
        clearTextFieldButton.setImage(Icon.close_24, for: .normal)
        clearTextFieldButton.imageView?.tintColor = .app
        clearTextFieldButton.addTarget(self, action: #selector(clearTextFieldButtonAction), for: .touchUpInside)
        textFieldView.addSubview(clearTextFieldButton)

        textFieldLine = UIView()
        textFieldLine.backgroundColor = .app
        textFieldView.addSubview(textFieldLine)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 4
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.register(WordTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

//        filterButton = UIButton()
//        filterButton.backgroundColor = .app
//        filterButton.setImage(Icon.filter_24, for: .normal)
//        filterButton.imageView?.tintColor = .white
////        filterButton.setTitle("  Filter", for: .normal)
////        filterButton.setTitleColor(.white, for: .normal)
////        filterButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 22)
//        filterButton.addShadow(cornerRadius: 28)
//        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
//        view.addSubview(filterButton)

        noResultsLabel = UILabel()
        noResultsLabel.text = Message.NO_RESULTS
        noResultsLabel.textColor = .app
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = Font.AlegreyaSans.bold(with: 24)
        noResultsLabel.numberOfLines = 2
        noResultsLabel.isHidden = true
        view.addSubview(noResultsLabel)

        infoLabel = UILabel()
        infoLabel.textColor = .app
        infoLabel.textAlignment = .left
        infoLabel.font = Font.AlegreyaSans.medium(with: 20 )
        view.addSubview(infoLabel)

        dividerView = UIView()
        dividerView.backgroundColor = .divider2
        view.addSubview(dividerView)

        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = Default.ADMOB_AD_UNIT_ID
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        view.addSubview(adBannerView)
    }
}
