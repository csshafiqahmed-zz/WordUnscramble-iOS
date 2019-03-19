import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: UIElements
    private var textFieldView: UIView!
    private var textField: TextField!
    private var clearTextFieldButton: UIButton!
    private var searchButton: UIButton!
    private var textFieldLine: UIView!

    private var tableView: UITableView!
    private var filterButton: UIButton!

    // MARK: Attributes
    private var data: [Section] = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupView()
        setupNavigationBar()
        addConstraints()

        let section1 = Section(name: "Section1", items: [Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word")])
        let section2 = Section(name: "Section2", items: [Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word")])
        let section3 = Section(name: "Section3", items: [Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word"), Item(name: "word")])
        data.append(contentsOf: [section1, section2, section3])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
    }

    @objc private func settingButtonAction() {

    }

    @objc private func donateButtonAction() {

    }

    @objc private func clearTextFieldButtonAction() {

    }

    @objc private func searchButtonAction() {

    }

    @objc private func filterButtonAction() {

    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].collapsed ? 0 : data[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WordTableViewCell ?? WordTableViewCell(style: .default, reuseIdentifier: "cell")

        let item: Item = data[indexPath.section].items[indexPath.row]

        cell.nameLabel.text = item.name

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    // Header
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")

        header.titleLabel.text = data[section].name
        header.section = section
        header.delegate = self
        return header
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
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
        navigationController?.navigationBar.layer.shadowColor = UIColor(hex: 0xbdbdbd).cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2

        // Title
        navigationController?.navigationBar.topItem?.title = "Unscramble"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.AlegreyaSans.bold(with: 32),
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]

        let settingButton = UIButton(type: .custom)
        settingButton.setImage(Icon.setting_24, for: .normal)
        settingButton.imageView?.tintColor = .white
        settingButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)

        let supportButton = UIButton(type: .custom)
        supportButton.setImage(Icon.support_24, for: .normal)
        supportButton.imageView?.tintColor = .white
        supportButton.addTarget(self, action: #selector(donateButtonAction), for: .touchUpInside)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16

        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: settingButton), space, UIBarButtonItem(customView: supportButton)]
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

        tableView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalToSuperview().inset(12)
            maker.top.equalTo(textFieldView.snp.bottom).offset(12)
            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
        }

        filterButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(12)
            maker.bottom.equalTo(self.view.layoutMarginsGuide.snp.bottom)
            maker.size.equalTo(56)
//            maker.centerX.equalToSuperview()
//            maker.top.bottom.equalToSuperview()
//            maker.width.equalTo(136)
        }
    }

    override func setupView() {
        textFieldView = UIView()
        textFieldView.backgroundColor = .white
        view.addSubview(textFieldView)

        textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: Message.TEXT_FIELD_PLACE_HOLDER,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xbdbdbd)])
        textField.font = Font.AlegreyaSans.medium(with: 24)
        textField.textColor = .app
        textField.tintColor = .app
        textFieldView.addSubview(textField)

        searchButton = UIButton()
        searchButton.backgroundColor = .clear //UIColor(hex: 0x0039cb)
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
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 6
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        filterButton = UIButton()
        filterButton.backgroundColor = .app
        filterButton.setImage(Icon.filter_24, for: .normal)
        filterButton.imageView?.tintColor = .white
//        filterButton.setTitle("  Filter", for: .normal)
//        filterButton.setTitleColor(.white, for: .normal)
//        filterButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 22)
        filterButton.addShadow(cornerRadius: 28)
        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        view.addSubview(filterButton)
    }
}
