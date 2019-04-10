import UIKit
import SnapKit
import BEMCheckBox

class FilterViewController: UIViewController {

    // MARK: UIElements
    private var backgroundView: UIView!
    private var alertView: UIView!
    private var headerLabel: UILabel!
    private var dividerView: UIView!
    private var startsWithLabel: UILabel!
    private var startsWithTextField: UITextField!
    private var endsWithLabel: UILabel!
    private var endsWithTextField: UITextField!
    private var dividerView2: UIView!
    private var dividerView3: UIView!
    private var wordLengthLabel: UILabel!
    private var radio1: BEMCheckBox!
    private var radio2: BEMCheckBox!
    private var radio3: BEMCheckBox!
    private var anyWordLengthLabel: UIButton!
    private var fixedWordLengthLabel: UIButton!
    private var rangeWordLengthLabel: UIButton!
    private var wordLengthFromButton: UIButton!
    private var wordLengthSelectionView: UIView!
    private var toLabel: UILabel!
    private var wordLengthToButton: UIButton!
    private var lettersLabel: UILabel!
//    private var sortLabel: UILabel!
//    private var sortButton: UIButton!

    // MARK: Attributes
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    private var radioGroup: BEMCheckBoxGroup!

    override func viewDidLoad() {
        super.viewDidLoad()

        radioGroup = BEMCheckBoxGroup()
        radioGroup.mustHaveSelection = true

        setupView()
        addConstraints()

        radioGroup.addCheckBox(toGroup: radio1)
        radioGroup.addCheckBox(toGroup: radio2)
        radioGroup.addCheckBox(toGroup: radio3)
        radioGroup.selectedCheckBox = radio1

        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        alertView.addGestureRecognizer(tapGesture)
        backgroundView.addGestureRecognizer(tapGesture)

        // pan gesture
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))

        // adding observers for keyboard notification change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // removing keyboard notification change observers
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc private func dismissView() {
        self.view.endEditing(true)
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

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        alertView.snp.updateConstraints { maker in
            maker.height.equalTo(300 + frame.height)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        alertView.snp.updateConstraints { maker in
            maker.height.equalTo(400)
        }
    }

    @objc private func wordLengthLabelAction(_ button: UIButton) {
        if button.tag == 0 {
            radioGroup.selectedCheckBox = radio1
        } else if button.tag == 1 {
            radioGroup.selectedCheckBox = radio2
        } else if button.tag == 2 {
            radioGroup.selectedCheckBox = radio3
        }
    }

    private func toggleWordLengthView() {

    }

}

extension FilterViewController {
    override func addConstraints() {
        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        alertView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(400)
        }

        headerLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(8)
            maker.height.equalTo(headerLabel.intrinsicContentSize.height)
        }

        dividerView.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(headerLabel.snp.bottom).offset(8)
            maker.height.equalTo(1)
        }

        startsWithLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.top.equalTo(dividerView.snp.bottom).offset(24)
            maker.width.equalTo(wordLengthLabel.intrinsicContentSize.width)
            maker.height.equalTo(42)
        }

        startsWithTextField.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(startsWithLabel.snp.top)
            maker.bottom.equalTo(startsWithLabel.snp.bottom)
            maker.left.equalTo(startsWithLabel.snp.right).offset(12)
        }

        dividerView2.snp.makeConstraints { maker in
            maker.left.equalTo(startsWithTextField.snp.left)
            maker.right.equalTo(startsWithTextField.snp.right).inset(8)
            maker.bottom.equalTo(startsWithTextField.snp.bottom).inset(4)
            maker.height.equalTo(2)
        }

        endsWithLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.top.equalTo(startsWithLabel.snp.bottom).offset(12)
            maker.width.equalTo(wordLengthLabel.intrinsicContentSize.width)
            maker.height.equalTo(42)
        }

        endsWithTextField.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(24)
            maker.top.equalTo(endsWithLabel.snp.top)
            maker.bottom.equalTo(endsWithLabel.snp.bottom)
            maker.left.equalTo(endsWithLabel.snp.right).offset(12)
        }

        dividerView3.snp.makeConstraints { maker in
            maker.left.equalTo(endsWithTextField.snp.left)
            maker.right.equalTo(endsWithTextField.snp.right).inset(8)
            maker.bottom.equalTo(endsWithTextField.snp.bottom).inset(4)
            maker.height.equalTo(2)
        }

        wordLengthLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(12)
            maker.top.equalTo(endsWithLabel.snp.bottom).offset(12)
            maker.width.equalTo(wordLengthLabel.intrinsicContentSize.width)
            maker.height.equalTo(42)
        }

        radio1.snp.makeConstraints { maker in
            maker.left.equalTo(wordLengthLabel.snp.right).offset(16)
            maker.centerY.equalTo(wordLengthLabel.snp.centerY)
            maker.size.equalTo(22)
        }

        anyWordLengthLabel.snp.makeConstraints { maker in
            maker.left.equalTo(radio1.snp.right).offset(8)
            maker.top.equalTo(wordLengthLabel.snp.top)
            maker.bottom.equalTo(wordLengthLabel.snp.bottom)
            maker.width.equalTo(anyWordLengthLabel.intrinsicContentSize.width)
        }

        radio2.snp.makeConstraints { maker in
            maker.left.equalTo(anyWordLengthLabel.snp.right).offset(16)
            maker.centerY.equalTo(radio1.snp.centerY)
            maker.size.equalTo(radio1.snp.size)
        }

        fixedWordLengthLabel.snp.makeConstraints { maker in
            maker.left.equalTo(radio2.snp.right).offset(8)
            maker.top.equalTo(wordLengthLabel.snp.top)
            maker.bottom.equalTo(wordLengthLabel.snp.bottom)
            maker.width.equalTo(fixedWordLengthLabel.intrinsicContentSize.width)
        }

        radio3.snp.makeConstraints { maker in
            maker.left.equalTo(fixedWordLengthLabel.snp.right).offset(16)
            maker.centerY.equalTo(radio1.snp.centerY)
            maker.size.equalTo(radio1.snp.size)
        }

        rangeWordLengthLabel.snp.makeConstraints { maker in
            maker.left.equalTo(radio3.snp.right).offset(8)
            maker.top.equalTo(wordLengthLabel.snp.top)
            maker.bottom.equalTo(wordLengthLabel.snp.bottom)
            maker.width.equalTo(rangeWordLengthLabel.intrinsicContentSize.width)
        }

        wordLengthSelectionView.snp.makeConstraints { maker in
            maker.left.equalTo(wordLengthLabel.snp.right).offset(16)
            maker.right.equalToSuperview().inset(16)
            maker.top.equalTo(wordLengthLabel.snp.bottom)
            maker.height.equalTo(42)
        }

        wordLengthFromButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(33)
            maker.width.equalTo(64)
        }

        toLabel.snp.makeConstraints { maker in
            maker.left.equalTo(wordLengthFromButton.snp.right).offset(8)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(toLabel.intrinsicContentSize)
        }

        wordLengthToButton.snp.makeConstraints { maker in
            maker.left.equalTo(toLabel.snp.right).offset(8)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(33)
            maker.width.equalTo(64)
        }

        lettersLabel.snp.makeConstraints { maker in
            maker.left.equalTo(wordLengthToButton.snp.right).offset(8)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(lettersLabel.intrinsicContentSize)
        }

//        sortLabel.snp.makeConstraints { maker in
//            maker.left.equalToSuperview().offset(12)
//            maker.top.equalTo(wordLengthSelectionView.snp.bottom).offset(12)
//            maker.width.equalTo(wordLengthLabel.intrinsicContentSize.width)
//            maker.height.equalTo(42)
//        }
//
//        sortButton.snp.makeConstraints { maker in
//            maker.left.equalTo(sortLabel.snp.right).offset(16)
//            maker.top.equalTo(sortLabel.snp.top)
//            maker.bottom.equalTo(sortLabel.snp.bottom)
//            maker.width.equalTo(150)
//        }
    }

    override func setupView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(backgroundView)

        alertView = UIView()
        alertView.backgroundColor = .white
        view.insertSubview(alertView, aboveSubview: backgroundView)

        headerLabel = UILabel()
        headerLabel.text = "Filters"
        headerLabel.textColor = .app
        headerLabel.textAlignment = .center
        headerLabel.font = Font.AlegreyaSans.bold(with: 32)
        alertView.addSubview(headerLabel)

        dividerView = UIView()
        dividerView.backgroundColor = .divider2
        alertView.addSubview(dividerView)

        startsWithLabel = UILabel()
        startsWithLabel.text = Message.STARTS_WITH
        startsWithLabel.textColor = .app
        startsWithLabel.textAlignment = .right
        startsWithLabel.font = Font.AlegreyaSans.medium(with: 22)
        alertView.addSubview(startsWithLabel)

        startsWithTextField = UITextField()
        startsWithTextField.font = Font.AlegreyaSans.medium(with: 22)
        startsWithTextField.textColor = .app
        startsWithTextField.tintColor = .app
        startsWithTextField.returnKeyType = .next
        startsWithTextField.autocapitalizationType = .none
        alertView.addSubview(startsWithTextField)

        dividerView2 = UIView()
        dividerView2.backgroundColor = .app
        alertView.addSubview(dividerView2)

        endsWithLabel = UILabel()
        endsWithLabel.text = Message.ENDS_WITH
        endsWithLabel.textColor = .app
        endsWithLabel.textAlignment = .right
        endsWithLabel.font = Font.AlegreyaSans.medium(with: 22)
        alertView.addSubview(endsWithLabel)

        endsWithTextField = UITextField()
        endsWithTextField.font = Font.AlegreyaSans.medium(with: 22)
        endsWithTextField.textColor = .app
        endsWithTextField.tintColor = .app
        endsWithTextField.returnKeyType = .next
        endsWithTextField.autocapitalizationType = .none
        alertView.addSubview(endsWithTextField)

        dividerView3 = UIView()
        dividerView3.backgroundColor = .app
        alertView.addSubview(dividerView3)

        wordLengthLabel = UILabel()
        wordLengthLabel.text = Message.WORD_LENGTH
        wordLengthLabel.textColor = .app
        wordLengthLabel.textAlignment = .left
        wordLengthLabel.font = Font.AlegreyaSans.medium(with: 22)
        alertView.addSubview(wordLengthLabel)

        radio1 = BEMCheckBox()
        radio1.onFillColor = .app
        radio1.onTintColor = .app
        radio1.onCheckColor = .white
        radio1.boxType = .circle
        radio1.onAnimationType = .fill
        radio1.offAnimationType = .fill
        radio1.animationDuration = 0.25
        alertView.addSubview(radio1)

        anyWordLengthLabel = UIButton()
        anyWordLengthLabel.setTitle("Any", for: .normal)
        anyWordLengthLabel.setTitleColor(.app, for: .normal)
//        anyWordLengthLabel.text = "Any"
//        anyWordLengthLabel.textColor = .app
//        anyWordLengthLabel.textAlignment = .left
        anyWordLengthLabel.titleLabel?.font = Font.AlegreyaSans.medium(with: 18)
        anyWordLengthLabel.tag = 0
        anyWordLengthLabel.addTarget(self, action: #selector(wordLengthLabelAction(_:)), for: .touchUpInside)
        alertView.addSubview(anyWordLengthLabel)

        radio2 = BEMCheckBox()
        radio2.onFillColor = .app
        radio2.onTintColor = .app
        radio2.onCheckColor = .white
        radio2.boxType = .circle
        radio2.onAnimationType = .fill
        radio2.offAnimationType = .fill
        radio2.animationDuration = 0.25
        alertView.addSubview(radio2)

        fixedWordLengthLabel = UIButton()
        fixedWordLengthLabel.setTitle("Fixed", for: .normal)
        fixedWordLengthLabel.setTitleColor(.app, for: .normal)
//        fixedWordLengthLabel.textAlignment = .left
        fixedWordLengthLabel.titleLabel?.font = Font.AlegreyaSans.medium(with: 18)
        fixedWordLengthLabel.tag = 1
        fixedWordLengthLabel.addTarget(self, action: #selector(wordLengthLabelAction(_:)), for: .touchUpInside)
        alertView.addSubview(fixedWordLengthLabel)

        radio3 = BEMCheckBox()
        radio3.onFillColor = .app
        radio3.onTintColor = .app
        radio3.onCheckColor = .white
        radio3.boxType = .circle
        radio3.onAnimationType = .fill
        radio3.offAnimationType = .fill
        radio3.animationDuration = 0.25
        alertView.addSubview(radio3)

        rangeWordLengthLabel = UIButton()
        rangeWordLengthLabel.setTitle("Range", for: .normal)
        rangeWordLengthLabel.setTitleColor(.app, for: .normal)
//        rangeWordLengthLabel.textAlignment = .left
        rangeWordLengthLabel.titleLabel?.font = Font.AlegreyaSans.medium(with: 18)
        rangeWordLengthLabel.tag = 2
        rangeWordLengthLabel.addTarget(self, action: #selector(wordLengthLabelAction(_:)), for: .touchUpInside)
        alertView.addSubview(rangeWordLengthLabel)

//        sortLabel = UILabel()
//        sortLabel.text = "Sort"
//        sortLabel.textColor = .app
//        sortLabel.textAlignment = .right
//        sortLabel.font = Font.AlegreyaSans.medium(with: 22)
//        alertView.addSubview(sortLabel)
//
//        sortButton = UIButton()
//        sortButton.setTitle("Alphabetical", for: .normal)
//        sortButton.setTitleColor(.app, for: .normal)
//        sortButton.backgroundColor = .white
//        sortButton.layer.borderColor = UIColor.app.cgColor
//        sortButton.layer.borderWidth = 1.5
//        sortButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 20)
//        sortButton.addShadow(cornerRadius: 4)
//        alertView.addSubview(sortButton)

        wordLengthSelectionView = UIView()
        wordLengthSelectionView.backgroundColor = .clear
        alertView.addSubview(wordLengthSelectionView)

        wordLengthFromButton = UIButton()
        wordLengthFromButton.backgroundColor = .white
        wordLengthFromButton.setTitle("2", for: .normal)
        wordLengthFromButton.setTitleColor(.app, for: .normal)
        wordLengthFromButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 16)
        wordLengthFromButton.setImage(Icon.arrow_down_24, for: .normal)
        wordLengthFromButton.imageView?.tintColor = .app
        wordLengthFromButton.semanticContentAttribute = .forceRightToLeft
        wordLengthFromButton.layer.borderColor = UIColor.app.cgColor
        wordLengthFromButton.layer.borderWidth = 1
        wordLengthFromButton.addShadow(cornerRadius: 4)
        wordLengthFromButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        wordLengthSelectionView.addSubview(wordLengthFromButton)

        toLabel = UILabel()
        toLabel.text = "to"
        toLabel.textColor = .app
        toLabel.font = Font.AlegreyaSans.regular(with: 14)
        wordLengthSelectionView.addSubview(toLabel)

        wordLengthToButton = UIButton()
        wordLengthToButton.backgroundColor = .white
        wordLengthToButton.setTitle("4", for: .normal)
        wordLengthToButton.setTitleColor(.app, for: .normal)
        wordLengthToButton.titleLabel?.font = Font.AlegreyaSans.medium(with: 16)
        wordLengthToButton.setImage(Icon.arrow_down_24, for: .normal)
        wordLengthToButton.imageView?.tintColor = .app
        wordLengthToButton.semanticContentAttribute = .forceRightToLeft
        wordLengthToButton.layer.borderColor = UIColor.app.cgColor
        wordLengthToButton.layer.borderWidth = 1
        wordLengthToButton.addShadow(cornerRadius: 4)
        wordLengthToButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        wordLengthSelectionView.addSubview(wordLengthToButton)

        lettersLabel = UILabel()
        lettersLabel.text = "letters"
        lettersLabel.textColor = .app
        lettersLabel.font = Font.AlegreyaSans.regular(with: 14)
        wordLengthSelectionView.addSubview(lettersLabel)
    }
}

