import Alamofire

protocol IESNetworkProvider {
    func loadExchangeRate(from cur1: Currency, to cur2: Currency, completion: @escaping (Result<Double, Error>) -> Void)
}

final class ESNetworProvider: IESNetworkProvider {
    func loadExchangeRate(from cur1: Currency, to cur2: Currency, completion: @escaping (Result<Double, Error>) -> Void) {
        AF
            .request("https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(cur1.code)/\(cur2.code).json")
            .responseJSON { response in
                switch response.result {
                case .success(let jsonAny):
                    guard let dictCur = jsonAny as? [String: Any] else { return }
                    guard let exchRate = dictCur[cur2.code] as? Double else { return }
                    completion(.success(exchRate))
                case .failure(let error):
                    guard let err = error.errorDescription  else { return }

                    completion(.failure(NSError(domain: err, code: 20)))
                }
            }
    }
}
