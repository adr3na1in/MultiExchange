protocol ICurDelegate {
    func curDidSet(_ cur: Currency)
}

final class CurDelegate {
    var cur: Currency?
    var didSetHandler: ((Currency) -> Void)?
}

extension CurDelegate: ICurDelegate {
    func curDidSet(_ cur: Currency) {
        self.cur = cur
        self.didSetHandler?(cur)
    }
}
