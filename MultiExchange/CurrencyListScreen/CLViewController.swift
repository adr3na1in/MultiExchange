import UIKit
protocol ICLViewController {
    func backward()
}
protocol ICLPresenter {
    func didLoad(vc: ICLViewController, ui: ICLView)
}

final class CLViewController: UIViewController {
    private let ui = CLView()
    private let presenter: ICLPresenter

    init(presenter: ICLPresenter) {
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
        self.presenter.didLoad(vc: self, ui: self.ui)
    }
}

extension CLViewController: ICLViewController {
    func backward() {
        self.navigationController?.popViewController(animated: true)
    }

}
