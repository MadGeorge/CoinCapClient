import Foundation
import OpenCombine
import OpenCombineDispatch
import OpenCombineFoundation

protocol IRemoteService {
    func fetch(ids: [String], force: Bool) -> AnyPublisher<[Model.Asset], Error>
    func fetch(limit: Int, offset: Int, force: Bool) -> AnyPublisher<[Model.Asset], Error>
    func search(text: String) -> AnyPublisher<[Model.Asset], Error>
    func history(id: String) -> AnyPublisher<[Model.Record], Error>
}

final class RemoteService: IRemoteService {
    private let session = URLSession(configuration: .default)

    func fetch(ids: [String], force: Bool) -> AnyPublisher<[Model.Asset], Error> {
        CoinCapAPIClient.url(for: .byIds(ids)).flatMap { url in
            session.ocombine
                .dataTaskPublisher(for: url)
                .tryMap { result in
                    guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .retry(1)
                .decode(type: Model.Assets.self, decoder: JSONDecoder())
                .map { $0.data }
                .eraseToAnyPublisher()
        } ?? Fail(error: Errors.unexpectedError).eraseToAnyPublisher()
    }

    func fetch(limit: Int, offset: Int, force: Bool) -> OpenCombine.AnyPublisher<[Model.Asset], Error> {
        CoinCapAPIClient.url(for: .list(limit, offset)).flatMap { url in
            session.ocombine
                .dataTaskPublisher(for: url)
                .tryMap { result in
                    guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .retry(1)
                .decode(type: Model.Assets.self, decoder: JSONDecoder())
                .map { $0.data }
                .eraseToAnyPublisher()
        } ?? Fail(error: Errors.unexpectedError).eraseToAnyPublisher()
    }

    func search(text: String) -> AnyPublisher<[Model.Asset], Error> {
        CoinCapAPIClient.url(for: .search(text)).flatMap { url in
            session.ocombine
                .dataTaskPublisher(for: url)
                .tryMap { result in
                    guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .retry(1)
                .decode(type: Model.Assets.self, decoder: JSONDecoder())
                .map { $0.data }
                .eraseToAnyPublisher()
        } ?? Fail(error: Errors.unexpectedError).eraseToAnyPublisher()
    }

    func history(id: String) -> AnyPublisher<[Model.Record], Error> {
        CoinCapAPIClient.url(for: .history(id)).flatMap { url in
            session.ocombine
                .dataTaskPublisher(for: url)
                .tryMap { result in
                    guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .retry(1)
                .decode(type: Model.History.self, decoder: JSONDecoder())
                .map { $0.data }
                .eraseToAnyPublisher()
        } ?? Fail(error: Errors.unexpectedError).eraseToAnyPublisher()
    }
}
