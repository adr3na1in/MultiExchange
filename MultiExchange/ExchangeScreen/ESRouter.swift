import UIKit
protocol IESRouter {
    func goToNextScreen(for pickedField: CurrencyComponent, _ setCurrencyHandler: @escaping ((Currency) -> Void), _ vcHandler: (UIViewController) -> Void)

}

final class ESRouter {

}

extension ESRouter: IESRouter {
    func goToNextScreen(for pickedField: CurrencyComponent, _ setCurrencyHandler: @escaping ((Currency) -> Void), _ vcHandler: (UIViewController) -> Void) {
        vcHandler(CLAssambly.makeModule(for: pickedField, setCurrencyHandler))
    }

}
