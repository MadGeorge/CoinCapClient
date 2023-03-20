import Foundation

struct Locker {
    private(set) var isLocked = false

    var isUnlocked: Bool { !isLocked }

    /// Returns true if locked
    mutating func passedThroughOnce() -> Bool {
        if isLocked { return true }
        isLocked = true

        return false
    }

    /// Executes closure if not locked and locks
    mutating func performOnce(_ block: @escaping VoidBlock) {
        if isLocked { return }
        isLocked = true

        block()
    }

    /// Returns true if locked
    mutating func doNotPassAndUnlockIfLocked() -> Bool {
        if isLocked {
            isLocked = false
            return true
        }

        return false
    }

    mutating func unlock() {
        isLocked = false
    }

    mutating func lock() {
        isLocked = true
    }
}
