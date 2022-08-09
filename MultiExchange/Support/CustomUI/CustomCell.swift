import UIKit
import SnapKit

final class CustomCell: UITableViewCell {
    static let tag = "Custom cell"
    static let height = Metrics.defaultHeight

    private lazy var currencyName: UILabel = {
        let obj = UILabel()
        obj.font = .boldSystemFont(ofSize: 24)
        obj.textColor = ColorPalette.lightPink
        return obj
    }()

    private lazy var flag: UIImageView = {
        let obj = UIImageView()
        return obj
    }()
}

extension CustomCell {
    func configView() {
        self.contentView.addSubview(self.currencyName)
        self.contentView.addSubview(self.flag)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 252, green: 15, blue: 192, alpha: 0.8)
        self.layer.cornerRadius = Metrics.cornerRadius

        self.flag.snp.makeConstraints { pin in
            pin.left.equalToSuperview().offset(Metrics.defaultIndent/4)
            pin.centerY.equalToSuperview()
            pin.width.equalTo(40)
            pin.height.equalTo(40)
        }

        self.currencyName.snp.makeConstraints { pin in
            pin.centerY.equalToSuperview()
            pin.left.equalTo(self.flag.snp.right).offset(Metrics.defaultIndent)
            pin.right.equalToSuperview().offset(-Metrics.defaultIndent/4)
            pin.height.equalTo(60)
        }
    }

    func fillCell(with currency: Currency) {
        if currency.isFavorite {
            self.currencyName.text = "\u{2605}   " + currency.name.uppercased()
        } else {
            self.currencyName.text = currency.name.uppercased()
        }

    }
}
