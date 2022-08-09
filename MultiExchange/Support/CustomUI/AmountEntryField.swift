import UIKit

final class AmountEntryField: TouchableView {
    var delegate: ICashDelegate?
    private lazy var amountCash: UILabel = {
        let obj = UILabel()
        obj.layer.cornerRadius = 16
        obj.backgroundColor = ColorPalette.lightGray
        obj.layer.masksToBounds = true
        obj.layer.borderColor = ColorPalette.neonPink.cgColor
        obj.layer.borderWidth = 2.0

        return obj
    }()

    private lazy var textAmount: UITextField = {
        let obj = UITextField()
        obj.delegate = self
        obj.adjustsFontSizeToFitWidth = true
        obj.keyboardType = .decimalPad
        obj.font = .boldSystemFont(ofSize: 32)
        obj.backgroundColor = .clear
        obj.textColor = ColorPalette.lightPink
        obj.attributedPlaceholder = NSAttributedString(
            string: "0.00",
            attributes: [NSAttributedString.Key.foregroundColor: ColorPalette.lightPink])
        return obj
    }()

    init() {
        super.init(frame: .null)
        self.layer.cornerRadius = 16
        self.configView()
        self.makeConstr()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AmountEntryField {
    func configView() {
        self.addSubview(self.amountCash)
        self.amountCash.addSubview(self.textAmount)
        self.tapHandler = { [weak self] in
            self?.textAmount.becomeFirstResponder()
        }
    }

    func makeConstr() {
        self.amountCash.snp.makeConstraints { pin in
            pin.edges.equalToSuperview()
        }
        self.textAmount.snp.makeConstraints { pin in
            pin.left.equalTo(self.amountCash).offset(20)
            pin.top.right.bottom.equalToSuperview()
        }
    }
}
extension AmountEntryField: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.amountCash.layer.borderColor = ColorPalette.neonCyan.cgColor
        guard let text = textField.text else { return }
        if let value = Double(text) {
            self.delegate?.cashDidSet(value)
        } else {
            self.delegate?.cashDidSet(0)
        }
    }
    
//    func borderColor() {
//        self.amountCash.layer.borderColor = ColorPalette.neonCyan.cgColor
//    }
}
