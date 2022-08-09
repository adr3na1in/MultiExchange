protocol IESInteractor {
    func solveResult(from cur1: Currency, to cur2: Currency, sum: Double, comletion: @escaping (Result<Double, Error>) -> Void)
    func trackPickedCurrency(_ cur: Currency, _ pickedField: CurrencyComponent)
}

final class ESInteractor {
    private let provider: IESNetworkProvider
    private let favoriteCurrencyManager: IFavoriteCurrencyManager

    init(provider: IESNetworkProvider, favoriteCurrencyManager: IFavoriteCurrencyManager) {
        self.provider = provider
        self.favoriteCurrencyManager = favoriteCurrencyManager
    }
}

extension ESInteractor: IESInteractor {

    func trackPickedCurrency(_ cur: Currency, _ pickedField: CurrencyComponent) {
        self.favoriteCurrencyManager.incrementCurrency(cur: cur, curComp: pickedField)
    }

    func solveResult(from cur1: Currency, to cur2: Currency, sum: Double, comletion: @escaping (Result<Double, Error>) -> Void) {
        self.provider.loadExchangeRate(from: cur1, to: cur2) { result in
            switch result {
            case .success(let exchangeRate):
                let result = sum * exchangeRate
                comletion(.success(result))
            case .failure(let error):
                comletion(.failure(error))
            }
        }
    }
}
