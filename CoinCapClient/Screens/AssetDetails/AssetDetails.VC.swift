import Foundation
import UIKit
import OpenCombine
import OpenCombineDispatch

extension AssetDetails {
    final class ViewController: BaseVC {
        private let search = UISearchController(searchResultsController: nil)
        private let adapter: Adapter
        private let viewModel: IAssetDetailsVM
        private var swipeActions: UISwipeActionsConfiguration?

        init(viewModel: IAssetDetailsVM, adapter: Adapter) {
            self.viewModel = viewModel
            self.adapter = adapter

            super.init()
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            navigationItem.largeTitleDisplayMode = .never

            setupTable()
            setupNavBarItems()
            bind()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            viewModel.viewEvents.send(.willAppear)
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }
    }
}


// MARK: - UITableViewDelegate

extension AssetDetails.ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = adapter.dataSource?.itemIdentifier(for: indexPath) else { return .zero }

        switch item {
        case .header:
            return 332

        case .row:
            return 44
        }
    }
}

// MARK: - Private

private extension AssetDetails.ViewController {
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
                    case let .title(name, symbol):
                        let attributedTitle = UILabel()
                        attributedTitle.attributedText = DataFormatter.assetTitle(name: name, symbol: symbol)
                        self?.navigationItem.largeTitleDisplayMode = .never
                        self?.navigationItem.titleView = attributedTitle

                    case let .watching(isWatching):
                        self?.navigationItem.rightBarButtonItem?.image = isWatching
                            ? Asset.Icons.heart.image
                            : Asset.Icons.heartEmpty.image

                    case let .data(snapshot):
                        self?.table.refreshControl?.endRefreshing()
                        self?.adapter.apply(snapshot)

                    case let .chart(data):
                        self?.table.visibleCells.first(where: { $0 is HeaderCell }).ifLet { cell in
                            (cell as? HeaderCell)?.draw(data)
                        }

                    case let .error(title, body):
                        self?.alert(title: title, body: body)
                    }
                }
            ))
    }

    func setupNavBarItems() {
        navigationItem.rightBarButtonItem = .init(
            image: Asset.Icons.heartEmpty.image,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonAction)
        )
    }

    @objc func rightBarButtonAction() {
        viewModel.viewEvents.send(.didSelectRightBarButton)
    }
}
