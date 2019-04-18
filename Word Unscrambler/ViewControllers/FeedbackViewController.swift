import UIKit
import SnapKit

class FeedbackViewController: UIViewController {

    // MARK: UIElements
    private var nameLabel: UILabel!
    private var nameTextField: UITextField!
    private var emailLabel: UILabel!
    private var emailTextField: UITextField!
    private var messageLabel: UILabel!
    private var messageTextView: UITextView!
    private var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupNavigationBar()
        setupView()
        addConstraints()

        // Hide keyboard tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc private func submitButtonAction() {
        let name = (nameTextField.text == nil) ? "Anonymous" : nameTextField.text!
        let email = (emailTextField.text == nil) ? "None" : emailTextField.text!
        let firebasePush = FirebasePush()
        firebasePush.pushFeedback(name: name, email: email, message: messageTextView.text)
        backButtonAction()
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    /**
        Dismisses keyboard on tap gesture outside of the textField view
     */
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let textFieldLocation = sender.location(in: nameTextField)
        let textViewLocation = sender.location(in: messageTextView)

        if !nameTextField.frame.contains(textFieldLocation) || !messageTextView.frame.contains(textViewLocation) {
            view.endEditing(true)
        }
    }
}

extension FeedbackViewController: UITextViewDelegate, UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextView.becomeFirstResponder()
        return false
    }

    public func textViewDidChange(_ textView: UITextView) {
        submitButton.isUserInteractionEnabled = textView.text.count > 5
        submitButton.backgroundColor = (textView.text.count > 5) ? .app : .lightGray
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let myText = textView.text else { return true }
        let count = myText.count + text.count - range.length
        return count <= 500
    }
}

extension FeedbackViewController {
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
        titleLabel.text = "Feedback"
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
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.textColor = .app
        nameLabel.textAlignment = .left
        nameLabel.font = Font.AlegreyaSans.bold(with: 24)
        view.addSubview(nameLabel)

        nameTextField = TextField()
        nameTextField.placeholder = "Enter you name"
        nameTextField.textColor = .app
        nameTextField.font = Font.AlegreyaSans.medium(with: 24)
        nameTextField.tintColor = .app
        nameTextField.returnKeyType = .next
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.app.cgColor
        nameTextField.layer.cornerRadius = 4
        view.addSubview(nameTextField)
        
        emailLabel = UILabel()
        emailLabel.text = "Email (optional)"
        emailLabel.textColor = .app
        emailLabel.textAlignment = .left
        emailLabel.font = Font.AlegreyaSans.bold(with: 24)
        view.addSubview(emailLabel)

        emailTextField = TextField()
        emailTextField.placeholder = "Enter your email"
        emailTextField.textColor = .app
        emailTextField.font = Font.AlegreyaSans.medium(with: 24)
        emailTextField.tintColor = .app
        emailTextField.returnKeyType = .next
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.app.cgColor
        emailTextField.layer.cornerRadius = 4
        view.addSubview(emailTextField)

        messageLabel = UILabel()
        messageLabel.text = "Message"
        messageLabel.textColor = .app
        messageLabel.textAlignment = .left
        messageLabel.font = Font.AlegreyaSans.bold(with: 24)
        view.addSubview(messageLabel)

        messageTextView = UITextView()
        messageTextView.delegate = self
        messageTextView.textColor = .app
        messageTextView.font = Font.AlegreyaSans.medium(with: 24)
        messageTextView.tintColor = .app
        messageTextView.layer.borderWidth = 1.0
        messageTextView.layer.borderColor = UIColor.app.cgColor
        messageTextView.layer.cornerRadius = 4
        view.addSubview(messageTextView)

        submitButton = UIButton()
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = Font.AlegreyaSans.bold(with: 28)
        submitButton.addShadow(cornerRadius: 4)
        submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        submitButton.isUserInteractionEnabled = false
        submitButton.backgroundColor = .lightGray
        view.addSubview(submitButton)
    }

    override func addConstraints() {
        submitButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            maker.height.equalTo(52)
        }

        nameLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.top.equalToSuperview().offset(12)
            maker.size.equalTo(nameLabel.intrinsicContentSize)
        }

        nameTextField.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(nameLabel.snp.bottom).offset(4)
            maker.height.equalTo(44)
        }

        emailLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.top.equalTo(nameTextField.snp.bottom).offset(16)
            maker.size.equalTo(emailLabel.intrinsicContentSize)
        }

        emailTextField.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(emailLabel.snp.bottom).offset(4)
            maker.height.equalTo(44)
        }

        messageLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.top.equalTo(emailTextField.snp.bottom).offset(16)
            maker.size.equalTo(messageLabel.intrinsicContentSize)
        }

        messageTextView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(24)
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(messageLabel.snp.bottom).offset(4)
            maker.bottom.equalTo(submitButton.snp.top).offset(-32)
        }
    }
}