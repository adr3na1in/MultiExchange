protocol ICLInteractor {
    func loadCurList(text: String, pickedField: CurrencyComponent, completion: @escaping (([Currency]) -> Void))
}

final class ClPresenter {
    private var vc: ICLViewController?
    private let interactor: ICLInteractor
    private let router: CLRouter
    private var ui: ICLView?
    private var currencies = [Currency]()
    private var setCurrencyHandler: (Currency) -> Void
    private let pickedField: CurrencyComponent

    init(pickedField: CurrencyComponent, interactor: ICLInteractor, router: CLRouter, setCurrencyHandler: @escaping (Currency) -> Void) {
        self.interactor = interactor
        self.router = router
        self.setCurrencyHandler = setCurrencyHandler
        self.pickedField = pickedField
    }
}

extension ClPresenter: ICLPresenter {

    func didLoad(vc: ICLViewController, ui: ICLView) {
        self.vc = vc
        self.ui = ui
        self.ui?.configView()
        self.hookUI()

        self.interactor.loadCurList(text: "", pickedField: self.pickedField) { [weak self] currencies in
            self?.currencies = currencies
            self?.ui?.reloadTable()
        }
    }
}

private extension ClPresenter {
    func hookUI() {

        self.ui?.changeTextHandler = { [weak self] text in
            guard let self = self else { return }
            self.interactor.loadCurList(text: text, pickedField: self.pickedField) { [weak self] currencies in
                self?.currencies = currencies
                self?.ui?.reloadTable()
            }
        }
        self.ui?.cellCountHandler = { [weak self] in
            self?.currencies.count ?? 0
        }
        self.ui?.getCurrencyHandler = { [weak self] index in
            self?.currencies[index]
        }
        self.ui?.didSelectRow = { [weak self] index in
            guard let self = self else { return }
            self.setCurrencyHandler(self.currencies[index])
            self.vc?.backward()
        }
    }
}
