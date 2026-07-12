// GoalView.swift — the goal planner: how much to save each month to hit a target.
import SwiftUI

struct GoalView: View {
    @State private var target: Double = 5_000_000
    @State private var years: Double = 15
    @State private var annualRate: Double = 12

    // Binary-search the monthly saving that reaches the target (uses the shared engine).
    var requiredMonthly: Double {
        var lo = 0.0, hi = 10_000_000.0
        for _ in 0..<60 {
            let mid = (lo + hi) / 2
            let plan = Investment(name: "", monthlyDeposit: mid,
                                  annualRatePercent: annualRate, years: Int(years))
            if plan.projectedValue < target { lo = mid } else { hi = mid }
        }
        return (hi / 100).rounded(.up) * 100
    }

    var planForChart: Investment {
        Investment(name: "", monthlyDeposit: requiredMonthly,
                   annualRatePercent: annualRate, years: Int(years))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("To reach your goal, save about")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Text(requiredMonthly.rupees + " / month")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.green)
                    }
                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text("Save \(requiredMonthly.rupees)/month for \(Int(years)) years to reach \(target.rupees). You'd deposit \((requiredMonthly * years * 12).rupees); compounding covers the rest.")
                        .font(.callout).padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    GrowthChartView(plan: planForChart)

                    Divider()
                    Text("Your goal").font(.headline)

                    goalSlider(title: "Target amount", value: target.rupees,
                               binding: $target, range: 100_000...50_000_000, step: 100_000)
                    goalSlider(title: "Years", value: "\(Int(years)) yrs",
                               binding: $years, range: 1...40, step: 1)
                    goalSlider(title: "Expected return", value: "\(String(format: "%.1f", annualRate))% / year",
                               binding: $annualRate, range: 1...20, step: 0.5)
                }
                .padding()
            }
            .navigationTitle("Reach a goal")
        }
    }

    func goalSlider(title: String, value: String,
                    binding: Binding<Double>, range: ClosedRange<Double>, step: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title).font(.subheadline)
                Spacer()
                Text(value).font(.subheadline).bold().foregroundStyle(.blue)
            }
            Slider(value: binding, in: range, step: step)
        }
    }
}

#Preview {
    GoalView()
}
