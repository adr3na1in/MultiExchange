import UIKit
import SnapKit

protocol IESView {
    func configView()
    func setTapHandler(for currencyComponent: CurrencyComponent, _ handler: @escaping () -> Void)
    func set(_ currencyComponent: CurrencyComponent, _ currency: Currency)
    func set(_ result: Double)
    func setDelegat(_ currencyComponent: CurrencyComponent, _ delegat: ICurDelegate)
    func setCashDelegate(_ delegate: ICashDelegate)
    //    func borderColorLeft()
    //    func borderColorRight()
    //    func borderColorCash()
}

final class ESView: UIView {
    
    private lazy var firstCurrency = CurrencyEntryComponent()
    private lazy var secondCurrency = CurrencyEntryComponent()
    // TODO: колво знаков после точки
    private lazy var amountCash = AmountEntryField()
    
    private lazy var banner: UILabel = {
        let obj = UILabel()
        obj.text = "Multi Exchange"
        obj.numberOfLines = 2
        obj.font = Fonts.font(type: .neon, size: .large)
        obj.textColor = ColorPalette.neonPink
        return obj
    }()
    
    private lazy var arrow: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "arrow1")
        return obj
    }()
    
    private lazy var resultConvers: UILabel = {
        let obj = UILabel()
        obj.layer.cornerRadius = 16
        obj.adjustsFontSizeToFitWidth = true
        obj.font = .boldSystemFont(ofSize: 32)
        obj.backgroundColor = ColorPalette.lightGray
        obj.layer.masksToBounds = true
        obj.textColor = ColorPalette.lightPink
        obj.textAlignment = .center
        obj.layer.borderColor = ColorPalette.neonCyan.cgColor
        obj.layer.borderWidth = 2.0
        return obj
    }()
    
    private lazy var favorites: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "star2")
        return obj
    }()
    
    private lazy var list: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "list")
        return obj
    }()
    
    private lazy var graph: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(named: "graph")
        return obj
    }()
}

extension ESView: IESView {
    
    func setTapHandler(for currencyComponent: CurrencyComponent, _ handler: @escaping () -> Void) {
        switch currencyComponent {
        case .first:
            self.firstCurrency.tapHandler = handler
        case .second:
            self.secondCurrency.tapHandler = handler
        }
    }
    
    func configView() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "fon")
        self.insertSubview(backgroundImage, at: 10)
        self.addSub()
        self.makeConst()
    }
    
    func setDelegat(_ currencyComponent: CurrencyComponent, _ delegat: ICurDelegate) {
        switch currencyComponent {
        case .first:
            self.firstCurrency.delegate = delegat
        case .second:
            self.secondCurrency.delegate = delegat
        }
        
    }
    func setCashDelegate(_ delegate: ICashDelegate) {
        self.amountCash.delegate = delegate
    }
    func set(_ currencyComponent: CurrencyComponent, _ currency: Currency) {
        
        switch currencyComponent {
        case .first:
            self.firstCurrency.set(currency)
        case .second:
            self.secondCurrency.set(currency)
        }
    }
    
    func set(_ result: Double) {
        if result >= 1 && result < 100 {
            self.resultConvers.text = "  \(NSString(format: "%.3f", result))    "
        }
        if result >= 0 && result < 1 {
            self.resultConvers.text = "  \(NSString(format: "%.5f", result))    "
        }
        if result >= 100 {
            self.resultConvers.text = "  \(NSString(format: "%.2f", result))    "
        }
        
    }
    
    //    func borderColorLeft() {
    //            self.firstCurrency.changeBorderColor()
    //    }
    //
    //    func borderColorRight() {
    //        self.secondCurrency.changeBorderColor()
    //    }
    
    
    
    //    func borderColorCash() {
    //        self.amountCash.borderColor()
    //    }
}

private extension ESView {
    func makeConst() {
        self.firstCurrency.snp.makeConstraints { pin in
            pin.top.equalToSuperview().offset(290)
            pin.left.equalToSuperview().offset(Metrics.defaultIndent)
            pin.width.equalTo(122)
            pin.height.equalTo(Metrics.defaultHeight)
        }
        
        self.arrow.snp.makeConstraints { pin in
            pin.left.equalTo(firstCurrency.snp.right).offset(10)
            pin.right.equalTo(secondCurrency.snp.left).offset(-10)
            pin.top.equalTo(firstCurrency.snp.top).offset(18)
            pin.height.equalTo(30)
        }
        
        self.secondCurrency.snp.makeConstraints { pin in
            pin.top.equalToSuperview().offset(290)
            pin.width.equalTo(122)
            pin.right.equalToSuperview().offset(-Metrics.defaultIndent)
            pin.height.equalTo(Metrics.defaultHeight)
        }
        
        self.amountCash.snp.makeConstraints { pin in
            pin.top.equalTo(firstCurrency.snp.bottom).offset(Metrics.defaultHeight)
            pin.left.equalToSuperview().offset(Metrics.defaultIndent)
            pin.width.equalTo(122)
            pin.height.equalTo(Metrics.defaultHeight)
        }
        
        self.resultConvers.snp.makeConstraints { pin in
            pin.top.equalTo(secondCurrency.snp.bottom).offset(Metrics.defaultHeight)
            pin.width.equalTo(122)
            pin.right.equalToSuperview().offset(-Metrics.defaultIndent)
            pin.height.equalTo(Metrics.defaultHeight)
        }
        
        self.favorites.snp.makeConstraints { pin in
            pin.height.equalTo(50)
            pin.width.equalTo(50)
            pin.left.equalToSuperview().offset(60)
            pin.bottom.equalToSuperview().offset(-50)
        }
        
        self.banner.snp.makeConstraints { pin in
            pin.top.equalToSuperview().offset(90)
            pin.left.equalToSuperview().offset(60)
            pin.right.equalToSuperview().offset(-10)
            pin.width.equalTo(190)
        }
        
        self.list.snp.makeConstraints { pin in
            pin.height.equalTo(65)
            pin.width.equalTo(65)
            pin.left.equalTo(favorites.snp.right).offset(35)
            pin.bottom.equalToSuperview().offset(-40)
        }
        
        self.graph.snp.makeConstraints { pin in
            pin.height.equalTo(65)
            pin.width.equalTo(65)
            pin.left.equalTo(list.snp.right).offset(35)
            pin.bottom.equalToSuperview().offset(-40)
        }
    }
    
    func addSub() {
        self.addSubview(self.firstCurrency)
        self.addSubview(self.arrow)
        self.addSubview(self.secondCurrency)
        self.addSubview(self.amountCash)
        self.addSubview(self.resultConvers)
        self.addSubview(self.favorites)
        self.addSubview(self.banner)
        self.addSubview(self.list)
        self.addSubview(self.graph)
        
    }
}
