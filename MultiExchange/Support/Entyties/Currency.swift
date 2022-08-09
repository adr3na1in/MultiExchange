struct Currency: Comparable {
    static func < (lhs: Currency, rhs: Currency) -> Bool {
        lhs.name < rhs.name
    }

    let code: String
    let name: String
    var isFavorite = false
}
