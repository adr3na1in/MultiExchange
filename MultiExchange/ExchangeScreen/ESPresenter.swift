import UIKit
protocol IESPresenter {
    func didLoad(ui: IESView, vc: IESViewController)
}

final class ESPresenter {
    private let interactor: IESInteractor
    private var vc: IESViewController?
    private var ui: IESView?
    private var router: IESRouter
    private var fstDelegat = CurDelegate()
    private var scdDelegat = CurDelegate()
    private var cashDelegat = CashDelegate()

    init(interactor: IESInteractor, router: IESRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ESPresenter: IESPresenter {
    func didLoad(ui: IESView, vc: IESViewController) {
        self.ui = ui
        self.vc = vc
        self.ui?.configView()
        self.hookUi()
        self.hookDelegat()
        self.ui?.setDelegat(.first, self.fstDelegat)
        self.ui?.setDelegat(.second, self.scdDelegat)
        self.ui?.setCashDelegate(self.cashDelegat)
    }
}

private extension ESPresenter {

    func hookUi() {

        self.ui?.setTapHandler(for: .first) { [weak self] in
            let setCurrencyHandler: ((Currency) -> Void) = { [weak self] currency in
                self?.ui?.set(.first, currency)
            }
            let goToNextScreenHandler: ((UIViewController) -> Void) = { [weak self] screen in
                self?.vc?.forward(to: screen)
            }
            self?.router.goToNextScreen(for: .first, setCurrencyHandler, goToNextScreenHandler)
        }

        self.ui?.setTapHandler(for: .second) { [weak self] in
            let setCurrencyHandler: ((Currency) -> Void) = { [weak self] currency in
                self?.ui?.set(.second, currency)
            }
            let goToNextScreenHandler: ((UIViewController) -> Void) = { [weak self] screen in
                self?.vc?.forward(to: screen)
            }
            self?.router.goToNextScreen(for: .second, setCurrencyHandler, goToNextScreenHandler)
        }

    }
    func hookDelegat() {
        self.fstDelegat.didSetHandler = { currency in
            self.interactor.trackPickedCurrency(currency, .first)
            self.solveResultIfCan()
        }
        self.scdDelegat.didSetHandler = { currency in
            self.interactor.trackPickedCurrency(currency, .second)
            self.solveResultIfCan()
        }
        self.cashDelegat.didSetHandler = {
            self.solveResultIfCan()
        }
    }
    // TODO: изменить цвет рамок при пустом поле
    func highlightIfNeeded() {
        if self.fstDelegat.cur == nil {
            print("left")
//            self.ui?.borderColorLeft()
        }
        if self.scdDelegat.cur == nil {
            print("right")
//            self.ui?.borderColorRight()

        }
        if self.cashDelegat.cash == nil {
            print("cash")
            
//            self.ui?.borderColorCash()
        }
    }

    func solveResultIfCan() {
        guard let curLeft = self.fstDelegat.cur,
              let curRight = self.scdDelegat.cur,
              let sum = self.cashDelegat.cash
        else {
            self.highlightIfNeeded()
            return
        }

        self.interactor.solveResult(
            from: curLeft,
            to: curRight,
            sum: sum) { result in
            switch result {
            case .success(let value):
                self.ui?.set(value)
            case .failure(let error):
                self.vc?.showAlert(with: "\(error)")
            }
        }
    }
}
