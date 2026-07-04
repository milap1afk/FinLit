// CompareView.swift — the "start early vs. start late" screen.
// Both people save the SAME amount and stop at the SAME age.
// The only difference is when they START. Compounding does the rest.

import SwiftUI
import Charts

// One labeled scenario we want to plot.
// Identifiable = each has a unique id, so ForEach and Charts can tell them apart.
struct Scenario: Identifiable {
    let id = UUID()
    let label: String
    let startAge: Int      // used to place the line on a shared age axis
    let plan: Investment
}

struct CompareView: View {

    // Same ₹5,000/month, same 12% return, both invest until age 55.
    // Early bird starts at 25 (30 years); late starter at 35 (20 years).
    let scenarios: [Scenario] = [
        Scenario(label: "Starts at 25", startAge: 25,
                 plan: Investment(name: "Early", monthlyDeposit: 5000, annualRatePercent: 12, years: 30)),
        Scenario(label: "Starts at 35", startAge: 35,
                 plan: Investment(name: "Late", monthlyDeposit: 5000, annualRatePercent: 12, years: 20))
    ]

    // The final-value gap between the early bird and the late starter.
    var difference: Double {
        let early = scenarios[0].plan.projectedValue
        let late = scenarios[1].plan.projectedValue
        return early - late
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Same ₹5,000/month, both invest until age 55. The only difference is starting 10 years earlier.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    // Headline: what those 10 extra years are worth.
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starting 10 years earlier is worth")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Text(difference.rupees)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.green)
                        Text("extra — for the same monthly saving.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Both lines on ONE chart, sharing an age axis.
                    // .foregroundStyle(by:) colours each scenario differently + adds a legend.
                    Chart {
                        ForEach(scenarios) { scenario in
                            ForEach(Array(scenario.plan.yearlyBalances().enumerated()), id: \.offset) { index, balance in
                                LineMark(
                                    x: .value("Age", scenario.startAge + index + 1),
                                    y: .value("Balance", balance)
                                )
                                .foregroundStyle(by: .value("Scenario", scenario.label))
                            }
                        }
                    }
                    .frame(height: 260)

                    // The two final totals, listed.
                    ForEach(scenarios) { scenario in
                        HStack {
                            Text(scenario.label)
                            Spacer()
                            Text(scenario.plan.projectedValue.rupees).bold()
                        }
                        .font(.subheadline)
                    }
                }
                .padding()
            }
            .navigationTitle("Compare")
        }
    }
}

#Preview {
    CompareView()
}
