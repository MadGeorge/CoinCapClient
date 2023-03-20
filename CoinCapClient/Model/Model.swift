import Foundation

enum Model {}

extension Model {
    struct Asset: Hashable, Equatable, Codable {
        let id: String
        let rank: String
        let symbol: String
        let name: String
        let supply: String?
        let maxSupply: String?
        let marketCapUsd: String?
        let volumeUsd24Hr: String?
        let priceUsd: String?
        let changePercent24Hr: String?
        let vwap24Hr: String?

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Asset, rhs: Asset) -> Bool {
            lhs.id == rhs.id
        }
    }

    struct Assets: Decodable {
        let data: [Asset]
    }
}

extension Model {
    enum AppIcon: String, CaseIterable {
        case white, black, yellow

        var title: String {
            switch self {
            case .white:
                return L10n.iconWhite

            case .black:
                return L10n.iconBlack

            case .yellow:
                return L10n.iconYellow
            }
        }

        var identifier: String {
            switch self {
            case .white:
                return "AppIcon-White"

            case .black:
                return "AppIcon-Black"

            case .yellow:
                return "AppIcon-Yellow"
            }
        }
    }
}

extension Model.AppIcon {
    init(id: String) {
        switch id {
        case Model.AppIcon.black.identifier:
            self = .black

        case Model.AppIcon.yellow.identifier:
            self = .yellow

        default:
            self = .white
        }
    }
}

extension Model {
    struct Record: Decodable {
        let priceUsd: String
        let time: Int
    }

    struct History: Decodable {
        let data: [Record]
    }
}
