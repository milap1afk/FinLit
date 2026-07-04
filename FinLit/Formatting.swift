// Formatting.swift — turns raw numbers into money people can read.
// 1161695  ->  "₹11,61,695"  (Indian digit grouping)

import Foundation

extension Double {
    // A computed property added onto every Double: ask any number for `.rupees`.
    var rupees: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_IN")  // Indian grouping (lakhs/crores)
        formatter.maximumFractionDigits = 0
        let number = formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))"
        return "₹\(number)"
    }
}
