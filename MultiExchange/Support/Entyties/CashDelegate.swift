protocol ICashDelegate {
    func cashDidSet(_ cash: Double)
}
final class CashDelegate {
    var cash: Double?
    var didSetHandler: (() -> Void)?
}

extension CashDelegate: ICashDelegate {
    func cashDidSet(_ cash: Double) {
        self.cash = cash
        self.didSetHandler?()
    }
}
