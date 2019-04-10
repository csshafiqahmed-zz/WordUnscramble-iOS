import UIKit
import SnapKit
import Lottie

class DefinitionViewController: UIViewController {

    // MARK: UIElements
    private var backgroundView: UIView!
    private var alertView: UIView!

    private var titleLabel: UILabel!
    private var internetButton: UIButton!
//    private var pronunciationButton: UIButton!
    private var favoriteButton: UIButton!
    private var phoneticLabel: UILabel!
    private var tableView: UITableView!
    private var animationView: LOTAnimationView!

    // MARK: Attributes
    public var word: String = ""
    private var firebaseWord: FirebaseWord?
    private var definitions = [String]()
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    private var definitionCacheController: DefinitionCacheController!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addConstraints()
        animationView.startAnimation()

        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)

        // pan gesture
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))

        definitionCacheController = DefinitionCacheController.getInstance()
        definitionCacheController.getDefinitionForWord(word) { completion in
            switch completion {
            case .success(let word):
                self.firebaseWord = word
                self.refreshView()
            case .wordDoesNotExists, .failure:
                return
            }
            self.animationView.stopAnimation()
        }
    }

    private func refreshView() {
        if firebaseWord != nil {
            internetButton.isHidden = false
            favoriteButton.isHidden = false
            tableView.isHidden = false

            titleLabel.text = getTitleLabelText()
            phoneticLabel.text = getPhoneticLabelText()
            definitions = getListOfDefinitions()

            titleLabel.snp.updateConstraints { maker in
                maker.height.equalTo(titleLabel.intrinsicContentSize.height)
            }

            phoneticLabel.snp.updateConstraints { maker in
                maker.height.equalTo(titleLabel.snp.height)
            }

            tableView.reloadData()
            tableView.layoutIfNeeded()
            alertView.snp.updateConstraints { maker in
                maker.height.equalTo(getAlertViewHeight())
            }
        }
    }

    private func getTitleLabelText() -> String {
        if let firebaseWord = firebaseWord, let syllable = firebaseWord.syllable, syllable != "" {
            return syllable
        }
        return word
    }

    private func getPhoneticLabelText() -> String {
        if let firebaseWord = firebaseWord, let phonetic = firebaseWord.phonetic {
            return phonetic.joined(separator: ", ")
        }
        return ""
    }

    private func getListOfDefinitions() -> [String] {
        var definitionList = [String]()
        if let firebaseWord = firebaseWord, let definitions = firebaseWord.definitions {
            for (key, value) in definitions {
                for def in value {
                    definitionList.append(def)
                }
            }
            return definitionList
        }
        return definitionList
    }

    private func getHeightForTableViewRow(_ text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.textColor = .app
        label.textAlignment = .left
        label.font = Font.AlegreyaSans.medium(with: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        let width = view.frame.width - 24 - 16 - 8 - 16
        label.frame = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        label.sizeToFit()
        let height = label.frame.height + 16
        return height
    }
    
    private func getAlertViewHeight() -> CGFloat {
        var height = 12 + titleLabel.intrinsicContentSize.height
        height += titleLabel.intrinsicContentSize.height
        height += 8 + tableView.contentSize.height + 4
        height += bottomLayoutMargin

        let maxHeight = view.frame.height * 0.6
        print(height)
        return min(height, maxHeight)
    }

    @objc private func dismissView() {
        self.dismiss(animated: true)
    }

    @objc private func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        let alertViewInitialY: CGFloat = view.frame.height - alertView.frame.height
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                let y = touchPoint.y - initialTouchPoint.y + alertViewInitialY
                alertView.frame = CGRect(x: 0, y: y, width: alertView.frame.size.width, height: alertView.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > (alertView.frame.height / 2.5) {
                dismissView()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alertView.frame = CGRect(x: 0, y: alertViewInitialY, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                })
            }
        }
    }
}

extension DefinitionViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definitions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DefinitionTableViewCell(style: .default, reuseIdentifier: "cell")

        cell.selectionStyle = .none

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -24

        let attributeString = NSMutableAttributedString(string: definitions[indexPath.row])
        attributeString.addAttributes([.font: Font.AlegreyaSans.medium(with: 20), .paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributeString.length))
//        cell.definitionLabel.attributedText = attributeString
        cell.definitionLabel.text = definitions[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForTableViewRow(definitions[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension DefinitionViewController {
    override func setupView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(backgroundView)

        alertView = UIView()
        alertView.backgroundColor = .white
        view.insertSubview(alertView, aboveSubview: backgroundView)

        titleLabel = UILabel()
        titleLabel.textColor = .app
        titleLabel.textAlignment = .left
        titleLabel.font = Font.AlegreyaSans.bold(with: 28)
        alertView.addSubview(titleLabel)

        internetButton = UIButton()
        internetButton.setImage(Icon.internet_24, for: .normal)
        internetButton.imageView?.tintColor = .app
        internetButton.isHidden = true
        alertView.addSubview(internetButton)

        /*pronunciationButton = UIButton()
        pronunciationButton.setImage(Icon.volume_24, for: .normal)
        pronunciationButton.imageView?.tintColor = .app
        alertView.addSubview(pronunciationButton)*/

        favoriteButton = UIButton()
        favoriteButton.setImage(Icon.star_outline_24, for: .normal)
        favoriteButton.imageView?.tintColor = .app
        favoriteButton.isHidden = true
        alertView.addSubview(favoriteButton)

        phoneticLabel = UILabel()
        phoneticLabel.textColor = .app
        phoneticLabel.textAlignment = .left
        phoneticLabel.font = Font.AlegreyaSans.regular(with: 20)
        alertView.addSubview(phoneticLabel)

        tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        alertView.addSubview(tableView)

        animationView = LOTAnimationView(name: LottieAnimation.lading_seesaw)
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        alertView.insertSubview(animationView, aboveSubview: tableView)

    }

    override func addConstraints() {
        let buttonHeight: CGFloat = 48
        let buttonWidth: CGFloat = 38

        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        alertView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(400)
//            maker.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
        }

        internetButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(7)
            maker.top.equalToSuperview()
            maker.height.equalTo(buttonHeight)
            maker.width.equalTo(buttonWidth)
        }

        /*pronunciationButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.right.equalTo(internetButton.snp.left)
            maker.height.equalTo(buttonHeight)
            maker.width.equalTo(buttonWidth)
        }*/

        favoriteButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.right.equalTo(internetButton.snp.left)
            maker.height.equalTo(buttonHeight)
            maker.width.equalTo(buttonWidth)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalTo(favoriteButton.snp.left).inset(12)
            maker.top.equalToSuperview().offset(12)
            maker.height.equalTo(titleLabel.intrinsicContentSize.height)
        }

        phoneticLabel.snp.makeConstraints { maker in
            maker.left.equalTo(titleLabel.snp.left)
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.right.equalTo(titleLabel.snp.right)
            maker.height.equalTo(titleLabel.snp.height)
        }

        tableView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(phoneticLabel.snp.bottom).offset(8)
        }

        animationView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(view.frame.width * 0.8)
        }
    }
}