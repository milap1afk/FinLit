// Investment.swift — the "brain" of FinLit: all the math, no UI.
// Kept separate from the screens on purpose, so the logic can be reused and tested.

import Foundation

// Everything needed to describe one investment plan.
struct Investment {
    let name: String            // e.g. "Index Fund"
    let monthlyDeposit: Double  // how much you put in each month
    let annualRatePercent: Double // expected yearly return, e.g. 8 means 8%
    let years: Int              // how long you invest for

    // Projects the final value: add the deposit each month, then let it grow.
    var projectedValue: Double {
        let monthlyRate = annualRatePercent / 100 / 12
        let months = years * 12
        var balance = 0.0
        for _ in 1...months {
            balance += monthlyDeposit          // you add money
            balance += balance * monthlyRate   // it earns a little return
        }
        return balance
    }

    // How much of the final value was YOUR money vs. growth from returns.
    var totalDeposited: Double { monthlyDeposit * Double(years * 12) }
    var growth: Double { projectedValue - totalDeposited }

    // How many times over your invested money multiplied.
    var growthMultiple: Double {
        totalDeposited == 0 ? 0 : projectedValue / totalDeposited
    }

    // A plain-language sentence — the whole point of FinLit is to explain, not just show.
    var insight: String {
        let multiple = String(format: "%.1f", growthMultiple)
        return "Every ₹1 you invest grows to about ₹\(multiple). Of your final total, \(growth.rupees) is pure growth — money you never had to deposit."
    }

    // One data point per year — exactly what the chart plots.
    func yearlyBalances() -> [Double] {
        let monthlyRate = annualRatePercent / 100 / 12
        var balance = 0.0
        var results: [Double] = []
        for month in 1...(years * 12) {
            balance += monthlyDeposit
            balance += balance * monthlyRate
            if month % 12 == 0 {           // every 12th month = end of a year
                results.append(balance)
            }
        }
        return results
    }
}
