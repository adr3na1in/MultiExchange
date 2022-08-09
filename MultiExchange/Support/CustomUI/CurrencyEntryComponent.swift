import UIKit

final class CurrencyEntryComponent: TouchableView {
    var delegate: ICurDelegate?

    private var cur: String?

    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.layer.cornerRadius = 16
        obj.backgroundColor = ColorPalette.lightGray
        obj.layer.masksToBounds = true
        obj.layer.borderColor = ColorPalette.neonPink.cgColor
        obj.layer.borderWidth = 2.0
        obj.textColor = ColorPalette.lightPink
        obj.textAlignment = .center
        obj.font = .systemFont(ofSize: 36)
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

private extension CurrencyEntryComponent {

    func configView() {
        self.addSubview(self.label)
    }

    func makeConstr() {
        self.label.snp.makeConstraints { pin in
            pin.edges.equalToSuperview()
        }
    }
}

extension CurrencyEntryComponent {
    func set(_ currency: Currency) {
        self.label.text = currency.code.uppercased()
        self.label.layer.borderColor = ColorPalette.neonCyan.cgColor
        self.delegate?.curDidSet(currency)
    }
    
//    func changeBorderColor() {
//        self.label.layer.borderColor = ColorPalette.neonCyan.cgColor
//    }
}
