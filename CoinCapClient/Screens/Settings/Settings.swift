import Foundation
import UIKit
import OpenCombine
import DiffableDataSources
import XCoordinator

protocol ISettingsSnapshotProvider: AnyObject {
    var snapshot: Settings.Snapshot? { get }
}

protocol ISettingsVM {
    var viewEvents: PassthroughSubject<Settings.ViewEvent, Never> { get set }
    var viewState: PassthroughSubject<Settings.ViewState, Never> { get }

    init(snapshotProvider: ISettingsSnapshotProvider, router: UnownedRouter<SettingsRoute>)
}

enum Settings {
    typealias Snapshot = DiffableDataSourceSnapshot<Section, SectionItem>

    enum ViewState {
        case data(Snapshot)

        /// Show alert
        /// - Parameters:
        ///     - first: title
        ///     - second: body
        case alert(String, String)
    }

    enum ViewEvent {
        case willAppear
        case didSelect(SectionItem)
    }

    enum Section: Int, Hashable {
        case icon
        case watchlist
    }

    enum SectionItem: Hashable {
        /// - Parameters:
        ///     - string: selected icon title
        case icon(String)

        case clearWatchlist
    }

    struct IconOption: Option {
        let title: String
        var value: Model.AppIcon
        var isSelected: Bool
    }

    static func build(router: UnownedRouter<SettingsRoute>) -> UIViewController {
        let adapter = Adapter()
        let vm = ViewModel(snapshotProvider: adapter, router: router)
        return ViewController(viewModel: vm, adapter: adapter)
    }
}
