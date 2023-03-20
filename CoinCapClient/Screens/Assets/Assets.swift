import Foundation
import UIKit
import OpenCombine
import DiffableDataSources
import XCoordinator

protocol IAssetsSnapshotProvider: AnyObject {
    var snapshot: Assets.Snapshot? { get }
}

protocol IAssetsVM {
    var searchEvents: PassthroughSubject<String, Never> { get }
    var viewEvents: PassthroughSubject<Assets.ViewEvent, Never> { get }
    var viewState: PassthroughSubject<Assets.ViewState, Never> { get }
    var router: UnownedRouter<AssetsRoute> { get }

    init(snapshotProvider: IAssetsSnapshotProvider, router: UnownedRouter<AssetsRoute>, mode: Assets.Mode)
}

enum Assets {
    typealias Snapshot = DiffableDataSourceSnapshot<Section, SectionItem>

    enum Mode {
        case list
        case favorite
        case search
    }

    enum ViewState {
        case loading
        case placeholder
        case data(Snapshot)

        /// Error state
        /// - Parameters:
        ///     - first: title
        ///     - second: body
        case error(String, String)
    }

    enum ViewEvent {
        case didAppear
        case didRefresh
        case didSelect(SectionItem)
        case didSwipe(SectionItem)
        case didReachPageBottom
        case didReloadSnapshot
    }

    enum Section: Hashable {
        case main
    }

    enum SectionItem: Hashable {
        case asset(Model.Asset)
        case activityIndicator
    }

    static func build(router: UnownedRouter<AssetsRoute>, mode: Assets.Mode) -> UIViewController {
        let title: String
        let tabIcon: UIImage?

        switch mode {
        case .list:
            title = L10n.assets
            tabIcon = Asset.Icons.bitcoinsign.image

        case .favorite:
            title = L10n.watchlist
            tabIcon = Asset.Icons.heart.image

        case .search:
            title = L10n.search
            tabIcon = nil
        }

        let adapter = Adapter()
        let vm = ViewModel(snapshotProvider: adapter, router: router, mode: mode)
        return ViewController(viewModel: vm, adapter: adapter, title: title, tabIcon: tabIcon, mode: mode)
    }
}
