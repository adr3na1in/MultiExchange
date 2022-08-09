import UIKit
enum CLAssambly {
    static func makeModule(for pickedField: CurrencyComponent, _ setCurrencyHandler: @escaping (Currency) -> Void) -> UIViewController {

        let provider = CLNetworkProvider()
        let favoriteCurrencyManager = CoreDataManager()
        let interactor = CLInteractor(provider: provider, favoriteCurrencyManager: favoriteCurrencyManager )
        let router = CLRouter()
        let presenter = ClPresenter(pickedField: pickedField, interactor: interactor, router: router, setCurrencyHandler: setCurrencyHandler)
        let vc = CLViewController(presenter: presenter)
        return vc
    }
}
