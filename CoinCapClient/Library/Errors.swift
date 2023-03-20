import Foundation

enum Errors: LocalizedError {
    case unexpectedError

    var errorDescription: String? {
        switch self {
        case .unexpectedError:
            return L10n.errUnexpectedError
        }
    }
}
