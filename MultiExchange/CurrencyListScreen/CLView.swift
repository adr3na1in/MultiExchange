import UIKit

protocol ICLView {
    func reloadTable()
    func configView()
    var cellCountHandler: (() -> Int)? { get set }
    var getCurrencyHandler: ((Int) -> Currency?)? { get set }
    var changeTextHandler: ((String) -> Void)? { get set }
    var didSelectRow: ((Int) -> Void)? { get set }
}

final class CLView: UIView {
    var cellCountHandler: (() -> Int)?
    var getCurrencyHandler: ((Int) -> Currency?)?
    var changeTextHandler: ((String) -> Void)?
    var didSelectRow: ((Int) -> Void)?

    private lazy var searchField: UITextField = {
        let obj = UITextField()
        obj.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: obj.frame.height))
        obj.leftViewMode = .always
        obj.placeholder = " Введите название валюты..."
        obj.backgroundColor = .white
        obj.delegate = self
        obj.layer.cornerRadius = Metrics.cornerRadius
        return obj
    }()

    private lazy var tableView: UITableView = {
        let obj = UITableView()
        obj.register(CustomCell.self, forCellReuseIdentifier: CustomCell.tag)
        obj.delegate = self
        obj.dataSource = self
        obj.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
        obj.layer.cornerRadius = Metrics.cornerRadius
        return obj
    }()
}

extension CLView: ICLView {

    func reloadTable() {
        self.tableView.reloadData()
    }

    func configView() {
        self.addSub()
        self.makeConstr()
    }
}

extension CLView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellCountHandler?() ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.tag, for: indexPath) as? CustomCell else { return UITableViewCell() }
        cell.configView()
        if let currency = self.getCurrencyHandler?(indexPath.row) {
            cell.fillCell(with: currency)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CustomCell.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow?(indexPath.row)
    }
}

extension CLView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.changeTextHandler?(textField.text ?? "")
    }
}
private extension CLView {
    func makeConstr() {
        self.searchField.snp.makeConstraints { pin in
            pin.left.equalToSuperview().offset(Metrics.defaultIndent)
            pin.right.equalToSuperview().inset(Metrics.defaultIndent)
            pin.top.equalTo(safeAreaLayoutGuide).offset(Metrics.defaultIndent)
            pin.height.equalTo(Metrics.defaultHeight / 2)
        }
        self.tableView.snp.makeConstraints { pin in
            pin.left.equalToSuperview().offset(Metrics.defaultIndent)
            pin.top.equalTo(self.searchField.snp.bottom).offset(Metrics.defaultIndent)
            pin.right.equalToSuperview().offset(-Metrics.defaultIndent)
            pin.bottom.equalToSuperview().offset(-Metrics.defaultIndent)
        }
    }

    func addSub() {
        self.addSubview(self.tableView)
        self.addSubview(self.searchField)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "fon")!)
    }
}
