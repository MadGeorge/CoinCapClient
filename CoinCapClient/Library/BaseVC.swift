import Foundation
import UIKit
import OpenCombine

class BaseVC: UIViewController {
    var tableStyle: UITableView.Style { .plain }

    lazy var table = UIFactory.table(style: tableStyle)
    var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.bgMain.color
        table.backgroundColor = Asset.Colors.bgMain.color

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic

        view.addSubview(table)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])

        table.tableFooterView = .init()
        table.showsVerticalScrollIndicator = false
        table.refreshControl = .init()
        table.refreshControl?.addTarget(self, action: #selector(didStartRefresh), for: .valueChanged)
    }

    func alert(title: String, body: String, button: String = L10n.ok) {
        let vc = UIAlertController(title: title, message: body, preferredStyle: .alert)
        vc.addAction(.init(title: button, style: .default, handler: { _ in
            vc.dismiss(animated: true)
        }))

        present(vc, animated: true)
    }

    func confirm(title: String, body: String, block: @escaping VoidBlock) {
    }

    /// Override in a subclass. Default implementation end refreshing immediately
    @objc func didStartRefresh() {
        table.refreshControl?.endRefreshing()
    }
}
