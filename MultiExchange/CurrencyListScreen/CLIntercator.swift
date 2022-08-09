protocol ICurrencyListLoader {
    func loadCurrencyList(completion: @escaping ([Currency]) -> Void)
}

final class CLInteractor {
    private let provider: ICurrencyListLoader
    private let favoriteCurrencyManager: IFavoriteCurrencyManager

    init(provider: ICurrencyListLoader, favoriteCurrencyManager: IFavoriteCurrencyManager) {
        self.provider = provider
        self.favoriteCurrencyManager = favoriteCurrencyManager
    }

}

extension CLInteractor: ICLInteractor {
    // TODO: фрматировать 2 таблицы списками избранных
    func loadCurList(text: String,
                     pickedField: CurrencyComponent,
                     completion: @escaping (([Currency]) -> Void)) {
        self.provider.loadCurrencyList { [weak self] curList in
            guard let self = self else { return }
            var favoriteCurList = self.favoriteCurrencyManager
                .loadPickedList(for: pickedField)
                .map { currency -> Currency in
                    var cur = currency
                    cur.isFavorite = true
                    return cur
                }
            favoriteCurList = [Currency](favoriteCurList[0..<(favoriteCurList.count >= 5 ? 5 : favoriteCurList.count)])
            let formatedCurList = self.formating(curList: curList, inputChar: text)
            completion(favoriteCurList + formatedCurList)
        }
    }

}

private extension CLInteractor {
    func formating(curList: [Currency], inputChar: String) -> [Currency] {
        let formatingList = curList.sorted()
        if inputChar.isEmpty {
            return formatingList
        }
        let filterList = formatingList.filter { curr in
            curr.code.contains(inputChar.lowercased()) || curr.name.contains(inputChar.lowercased())
        }
        return filterList
    }
}
