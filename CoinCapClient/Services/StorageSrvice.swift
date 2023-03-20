import Foundation
import OpenCombine
import OpenCombineDispatch
import OrderedCollections

protocol IStorageService {
    var watching: OrderedSet<Model.Asset> { get }

    func watch(_ asset: Model.Asset)
    func unWatch(_ asset: Model.Asset)
    func clearWatched()

    /// Add asses to the favourites if it is not watched or remove in opposite case
    /// - Returns: Is asset is saved as the favourite or not after toggle
    func toggle(_ asset: Model.Asset) -> Bool
}

final class StorageService: IStorageService {
    private(set) var watching = OrderedSet<Model.Asset>()

    init() {
        load()
    }

    func watch(_ asset: Model.Asset) {
        watching.append(asset)
        save()
    }

    func unWatch(_ asset: Model.Asset) {
        watching.remove(asset)
        save()
    }

    func toggle(_ asset: Model.Asset) -> Bool {
        if watching.contains(asset) {
            unWatch(asset)
            return false
        }

        watch(asset)
        return true
    }

    func clearWatched() {
        watching.removeAll()
        save()
    }
}

// MARK: - Private

private extension StorageService {
    var fileURL: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("watching.json")
    }
    func load() {
        do {
            try fileURL.flatMap { try Data(contentsOf: $0) }.ifLet {
                watching = try JSONDecoder().decode(OrderedSet<Model.Asset>.self, from: $0)
            }
        } catch {
            print("StorageService: Load data error:", error)
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(watching)
            try fileURL.ifLet { try data.write(to: $0) }
        } catch {
            print("StorageService: Save data error:", error)
        }
    }
}
