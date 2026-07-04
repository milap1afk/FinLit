// GrowthChartView.swift — draws the accelerating growth curve.
// Uses Apple's built-in "Charts" framework. You give it data, it draws.

import SwiftUI
import Charts   // Apple's charting framework — free, native, no libraries to install.

struct GrowthChartView: View {
    let plan: Investment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Growth over time")
                .font(.headline)

            // Chart wraps a set of marks (the things drawn). We loop over each
            // year's balance and draw one point + connect them into a line.
            Chart {
                // .enumerated() gives us both the position (year) and the value.
                ForEach(Array(plan.yearlyBalances().enumerated()), id: \.offset) { index, balance in

                    // A LineMark connects the dots into a curve.
                    LineMark(
                        x: .value("Year", index + 1),
                        y: .value("Balance", balance)
                    )

                    // A PointMark puts a dot at each year so it's clear.
                    PointMark(
                        x: .value("Year", index + 1),
                        y: .value("Balance", balance)
                    )
                }
            }
            .frame(height: 240)   // how tall the chart is on screen
        }
        .padding()
    }
}

#Preview {
    GrowthChartView(plan: Investment(name: "Demo",
                                     monthlyDeposit: 5000,
                                     annualRatePercent: 12,
                                     years: 10))
}
