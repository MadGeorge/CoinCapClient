import Foundation
import UIKit
import OpenCombine
import OpenCombineDispatch

extension Settings {
    final class ViewController: BaseVC {
        private let search = UISearchController(searchResultsController: nil)
        private let adapter: Adapter
        private let viewModel: ISettingsVM

        override var tableStyle: UITableView.Style { .grouped }

        init(viewModel: ISettingsVM, adapter: Adapter) {
            self.viewModel = viewModel
            self.adapter = adapter

            super.init()

            tabBarItem = .init(
                title: L10n.assets,
                image: Asset.Icons.bitcoinsign.image,
                selectedImage: Asset.Icons.bitcoinsign.image
            )
            tabBarItem.accessibilityLabel = UITests.Identifiers.tabSettings
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            title = L10n.settings
            setupTable()

            bind()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            viewModel.viewEvents.send(.willAppear)
        }
    }
}

// MARK: - UITableViewDelegate

extension Settings.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = adapter.dataSource?.itemIdentifier(for: indexPath) {
            viewModel.viewEvents.send(.didSelect(item))
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

// MARK: - Private

private extension Settings.ViewController {
    func setupTable() {
        table.delegate = self
        adapter.adapt(table)
    }

    func bind() {
        viewModel.viewState
            .receive(on: DispatchQueue.main.ocombine)
            .subscribe(Subscribers.Sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] state in
                    switch state {
                    case let .data(snapshot):
                        self?.table.refreshControl?.endRefreshing()
                        self?.adapter.apply(snapshot)

                    case let .alert(title, body):
                        self?.alert(title: title, body: body)
                    }
                }
            ))
    }
}
