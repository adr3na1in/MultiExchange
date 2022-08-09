import Alamofire
final class CLNetworkProvider: ICurrencyListLoader {
    func loadCurrencyList(completion: @escaping ([Currency]) -> Void) {
        AF
            .request("https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json")
            .responseJSON { response in
                switch response.result {
                case .success(let jsonAny):
                    guard let dictCur = jsonAny as? [String: String] else { return }
                    let currencies = dictCur.map { code, name in
                        Currency(code: code.lowercased(), name: name.lowercased())
                    }
                    completion(currencies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
