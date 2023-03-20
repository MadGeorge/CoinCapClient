import Foundation
import UIKit
import OpenCombine
import OpenCombineDispatch

extension Assets {
    final class ViewController: BaseVC {
        private var search: UISearchController?
        private let adapter: Adapter
        private let viewModel: IAssetsVM
        private let mode: Assets.Mode
        private let placeholder = WatchlistPlaceholder()

        init(viewModel: IAssetsVM, adapter: Adapter, title: String, tabIcon: UIImage?, mode: Assets.Mode) {
            self.viewModel = viewModel
            self.adapter = adapter
            self.mode = mode

            super.init()

            self.title = title
            self.tabBarItem = .init(title: title, image: tabIcon, selectedImage: tabIcon)

            switch mode {
            case .list, .search:
                self.tabBarItem.accessibilityLabel = UITests.Identifiers.tabAssets

            case .favorite:
                self.tabBarItem.accessibilityLabel = UITests.Identifiers.tabWatchlist
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            setupSearchBar()
            setupPlaceholder()
            setupTable()
            bind()
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            viewModel.viewEvents.send(.didAppear)
        }

        @objc override func didStartRefresh() {
            viewModel.viewEvents.send(.didRefresh)
        }
    }
}

// MARK: - UISearchControllerDelegate

extension Assets.ViewController: UISearchControllerDelegate {}

// MARK: - UISearchBarDelegate

extension Assets.ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        (search?.searchResultsController as? Assets.ViewController)?
            .viewModel.searchEvents.send(searchText)
    }
}

// MARK: - UITableViewDelegate

extension Assets.ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = scrollView.bounds.height
        let threshHold = scrollHeight
        let distance = (scrollView.contentSize.height - scrollView.contentOffset.y - scrollHeight)

        if scrollHeight != .zero, distance > .zero, distance <= threshHold {
            viewModel.viewEvents.send(.didReachPageBottom)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = adapter.dataSource?.itemIdentifier(for: indexPath) {
            viewModel.viewEvents.send(.didSelect(item))
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            self?.adapter.dataSource?.itemIdentifier(for: indexPath).ifLet { item in
                self?.viewModel.viewEvents.send(.didSwipe(item))
            }
            completion(true)
        }

        switch mode {
        case .favorite:
            action.backgroundColor = Asset.Colors.bgError.color
            action.title = L10n.remove
            action.accessibilityLabel = UITests.Identifiers.stopToWatch

        case .list, .search:
            action.backgroundColor = Asset.accentColor.color
            action.accessibilityLabel = UITests.Identifiers.startToWatch

            if #available(iOS 13.0, *) {
                action.image = Asset.Icons.heart.image.withTintColor(.white, renderingMode: .alwaysTemplate)
            } else {
                action.title = L10n.watch
            }
        }

        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = true

        return config
    }
}

// MARK: - Private

private extension Assets.ViewController {
    func setupPlaceholder() {
        view.insertSubview(placeholder, aboveSubview: table)

        NSLayoutConstraint.activate([
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        placeholder.isHidden = true
    }

    func setupSearchBar() {
        if mode != .list { return }

        search = .init(searchResultsController: Assets.build(router: viewModel.router, mode: .search))
        search?.delegate = self
        search?.searchBar.delegate = self
        search?.searchBar.placeholder = L10n.searchPlaceholder
        navigationItem.searchController = search
    }

    func setupTable() {
        table.delegate = self
        adapter.adapt(table)
    }

    func animateBottomCell() {
        table.visibleCells.first(where: { $0 is LoadingCell }).ifLet { cell in
            (cell as? LoadingCell)?.startAnimating()
        }
    }

    func stopBottomCellAnimation() {
        table.visibleCells.first(where: { $0 is LoadingCell }).ifLet { cell in
            (cell as? LoadingCell)?.stopAnimating()
        }
    }

    func bind() {
        viewModel.viewState
            .receive(on: DispatchQueue.main.ocombine)
            .subscribe(Subscribers.Sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] state in
                    switch state {
                    case .loading:
                        self?.placeholder.isHidden = true
                        self?.animateBottomCell()

                    case .placeholder:
                        self?.table.alpha = .zero
                        self?.table.isUserInteractionEnabled = false
                        self?.placeholder.isHidden = false
                        self?.stopBottomCellAnimation()

                    case let .data(snapshot):
                        self?.placeholder.isHidden = true
                        self?.table.alpha = 1
                        self?.table.isUserInteractionEnabled = true
                        self?.table.refreshControl?.endRefreshing()
                        self?.stopBottomCellAnimation()
                        self?.adapter.apply(snapshot) {
                            self?.viewModel.viewEvents.send(.didReloadSnapshot)
                        }

                    case let .error(title, body):
                        self?.alert(title: title, body: body)
                    }
                }
            ))
    }
}
