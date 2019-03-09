import UIKit
import SnapKit

class MainViewController: UIViewController {

    // MARK: UIElements
    private var textField: TextField!
    private var textFieldClearButton: UIButton!
    private var searchButton: UIButton!
    private var searchButton2: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .app
        navigationController?.navigationBar.barTintColor = .app
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false

        // Title
        navigationController?.navigationBar.topItem?.title = "Unscramble"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.AlegreyaSans.bold(with: 32),
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]

        setupView()
        addConstraints()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return  .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
    }

    override func addConstraints() {

        searchButton2.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(12)
            maker.top.equalToSuperview().offset(12)
            maker.size.equalTo(48)
        }

        textField.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalTo(searchButton2.snp.left).inset(-8)
            maker.top.equalToSuperview().offset(12)
            maker.height.equalTo(48)
        }

        searchButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalToSuperview().inset(12)
            maker.top.equalTo(textField.snp.bottom).offset(12)
            maker.height.equalTo(50)
        }
    }

    override func setupView() {
        textField = TextField()
        textField.attributedPlaceholder = NSAttributedString(string: Message.TEXT_FIELD_PLACE_HOLDER,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xbdbdbd)])
        textField.font = Font.AlegreyaSans.medium(with: 24)
        textField.textColor = .white
        textField.layer.borderWidth = 0.75
        textField.layer.borderColor = UIColor.greyWhite.cgColor
        textField.tintColor = .highlight
        textField.layer.cornerRadius = 6
        view.addSubview(textField)

        textFieldClearButton = UIButton(type: .custom)
        textFieldClearButton.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        textFieldClearButton.setImage(Icon.close_24, for: .normal)
        textFieldClearButton.imageView?.tintColor = .greyWhite
        textField.rightView = textFieldClearButton
        textField.rightViewMode = .always

        searchButton = UIButton()
        searchButton.backgroundColor = .highlight //UIColor(hex: 0xeeeeee)
        searchButton.setTitle("Unscramble", for: .normal)
        searchButton.setTitleColor(.greyWhite, for: .normal)
        searchButton.titleLabel?.font = Font.AlegreyaSans.bold(with: 24)
        searchButton.layer.cornerRadius = 4
        searchButton.isHidden = true
        view.addSubview(searchButton)

        searchButton2 = UIButton()
        searchButton2.backgroundColor = .highlight //UIColor(hex: 0xeeeeee)
        searchButton2.setImage(Icon.search_24, for: .normal)
        searchButton2.imageView?.tintColor = .greyWhite
        searchButton2.layer.cornerRadius = 6
        view.addSubview(searchButton2)
    }
}

extension MainViewController: UITextFieldDelegate {

}