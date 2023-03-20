import Foundation

extension Optional where Wrapped: ExpressibleByIntegerLiteral {
    var zeroIfNil: Wrapped {
        switch self {
        case let .some(value):
            return value

        default:
            return 0
        }
    }
}

extension Optional where Wrapped == Bool {
    var falseIfNil: Wrapped {
        switch self {
        case let .some(value):
            return value

        default:
            return false
        }
    }

    var trueIfNil: Wrapped {
        switch self {
        case let .some(value):
            return value

        default:
            return true
        }
    }
}

extension Optional where Wrapped == String {
    var emptyIfNil: Wrapped {
        switch self {
        case let .some(value):
            return value

        default:
            return ""
        }
    }

    var nilIfEmpty: Wrapped? {
        switch self {
        case let .some(value) where !value.isEmpty:
            return value

        default:
            return nil
        }
    }
}

extension Optional where Wrapped == Character {
    var emptyIfNil: Wrapped {
        switch self {
        case let .some(value):
            return value

        default:
            return Character("")
        }
    }
}

extension Optional {
    func ifLet(_ block: ((Wrapped) throws -> Void)?) rethrows {
        if let value = self {
            try block?(value)
        }
    }

    func ifLet(_ block: (Wrapped) throws -> Void) rethrows {
        if let value = self {
            try block(value)
        }
    }
}
