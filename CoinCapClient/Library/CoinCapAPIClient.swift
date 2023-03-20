import Foundation

enum CoinCapAPIClient {
    enum Endpoint {
        /// - Parameters:
        ///     - first: limit
        ///     - second: offset
        case list(Int, Int)

        /// - Parameters:
        ///     - first: search phrase
        case search(String)

        /// - Parameters:
        ///     - first: assets ids
        case byIds([String])

        /// - Parameters:
        ///     - first: asset id
        case history(String)
    }
}

extension CoinCapAPIClient.Endpoint {
    var path: String {
        switch self {
        case .list:
            return "assets"

        case .search:
            return "assets"

        case .byIds:
            return "assets"

        case let .history(id):
            return "assets/\(id)/history"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(limit, offset):
            return [
                .init(name: "limit", value: String(limit)),
                .init(name: "offset", value: String(offset)),
            ]

        case let .search(query):
            return [
                .init(name: "search", value: query),
                .init(name: "limit", value: "100"),
                .init(name: "offset", value: "0"),
            ]

        case let .byIds(ids):
            return [.init(name: "ids", value: ids.joined(separator: ","))]

        case .history:
            let now = Date()
            return [
                .init(name: "interval", value: "m5"),
                .init(name: "start", value: String(now.addingTimeInterval(-86400).unixMilliseconds)),
                .init(name: "end", value: String(now.unixMilliseconds)),
            ]
        }
    }

    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coincap.io"
        components.path = ["/v2", path].joined(separator: "/")
        components.queryItems = queryItems

        return components
    }
}

extension CoinCapAPIClient {
    static func url(for endpoint: Endpoint) -> URL? {
        let url = endpoint.urlComponents.url

        if ProcessInfo.processInfo.environment["NETWORK_LOGGING_ENABLED"] == "YES" {
            print("GET:", url ?? "URL construction error")
        }

        return url
    }
}
