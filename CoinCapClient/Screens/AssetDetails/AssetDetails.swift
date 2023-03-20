import Foundation
import UIKit
import OpenCombine
import DiffableDataSources
import XCoordinator

protocol IAssetDetailsSnapshotProvider: AnyObject {
    var snapshot: AssetDetails.Snapshot? { get }
}

protocol IAssetDetailsVM {
    var viewEvents: PassthroughSubject<AssetDetails.ViewEvent, Never> { get set }
    var viewState: PassthroughSubject<AssetDetails.ViewState, Never> { get }

    init(asset: Model.Asset, snapshotProvider: IAssetDetailsSnapshotProvider, router: UnownedRouter<AssetsRoute>)
}

enum AssetDetails {
    typealias Snapshot = DiffableDataSourceSnapshot<Section, SectionItem>

    enum ViewState {
        /// - Parameters:
        ///     - first: name
        ///     - second: symbol
        case title(String, String)

        case watching(Bool)
        case data(Snapshot)
        case chart([Model.Record])

        /// Error state
        /// - Parameters:
        ///     - first: title
        ///     - second: body
        case error(String, String)
    }

    enum ViewEvent {
        case willAppear
        case didSelect(SectionItem)
        case didSelectRightBarButton
    }

    enum Section: Hashable {
        case main
    }

    enum SectionItem: Hashable {
        case header(String, String)
        case row(String, String)
    }

    static func build(asset: Model.Asset, router: UnownedRouter<AssetsRoute>) -> UIViewController {
        let adapter = Adapter()
        let vm = ViewModel(asset: asset, snapshotProvider: adapter, router: router)
        let vc = ViewController(viewModel: vm, adapter: adapter)

        return vc
    }
}
