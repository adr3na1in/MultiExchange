import UIKit

protocol IESViewController {
    func forward(to screen: UIViewController)
    func showAlert(with message: String)
}

final class ESViewController: UIViewController {

    private let ui = ESView()
    private let presenter: IESPresenter

    init(presenter: IESPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = self.ui
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.didLoad(ui: self.ui, vc: self)

//MARK: test core data
//        let core = CoreDataManager()
//        core.deleteAll()
//        print(core.loadPickedList(for: .first))
//        print(core.loadPickedList(for: .second))

    }
}

extension ESViewController: IESViewController {
    func forward(to screen: UIViewController) {
        self.navigationController?.pushViewController(screen, animated: true)
    }

    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel))
        self.present(alertController, animated: true)
    }
}
