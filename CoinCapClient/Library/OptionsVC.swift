import Foundation
import UIKit

protocol Option {
    associatedtype T

    var title: String { get }
    var value: T { get }
    var isSelected: Bool { get }
}

final class OptionsVC<T: Option>: BaseVC, UITableViewDataSource, UITableViewDelegate {
    private let cellID = "Cell"

    let options: [T]

    override var tableStyle: UITableView.Style { .grouped }

    var didSelect: ((T) -> Void)?

    init(options: [T], title: String) {
        self.options = options

        super.init()

        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        table.dataSource = self
        table.delegate = self
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = option.title
        cell.accessoryType = option.isSelected ? .checkmark : .none

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(options[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
