import UIKit

final class ESAssambly {

    static func makeModule() -> UIViewController {

        let provider = ESNetworProvider()
        let favoriteCurrencyManager = CoreDataManager()
        let interactor = ESInteractor(provider: provider, favoriteCurrencyManager: favoriteCurrencyManager)
        let router = ESRouter()
        let presenter = ESPresenter(interactor: interactor, router: router)
        let vc = ESViewController(presenter: presenter)

        return vc
    }
}
