import Foundation
import UIKit

enum DataFormatter {
    /// Chop all but 2 characters after a dot and ads % suffix
    static func percent(_ input: String) -> String {
        if input.isEmpty { return "0%" }

        var result = input

        if let index = input.firstIndex(of: ".") {
            if index == input.index(before: input.endIndex) {
                result = String(input.dropLast())
            } else if let chopIndex = input.index(index, offsetBy: 3, limitedBy: input.endIndex) {
                result = String(input[input.startIndex..<chopIndex])
            }
        }

        return result + "%"
    }

    static func usd(_ input: String, maxFraction: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let number = formatter.number(from: input) ?? .init(value: 0)

        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = maxFraction

        let output = formatter.string(from: number) ?? input

        if output.hasSuffix(".00") {
            return String(output.dropLast(3))
        }

        return output
    }
}
