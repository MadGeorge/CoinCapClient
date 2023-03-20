import Foundation

extension Date {
    var unixMilliseconds: Int64 {
        Int64(round(timeIntervalSince1970 * 1000))
    }
}
