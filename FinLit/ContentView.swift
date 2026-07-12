// ContentView.swift — FinLit's home screen, now INTERACTIVE.
// The user drags sliders; the numbers and chart update live.

import SwiftUI
import Foundation

struct PlanView: View {

    @State private var monthlyDeposit: Double = 5000
    @State private var annualRate: Double = 12
    @State private var years: Double = 10
    @State private var inflation: Double = 6   // to show value in today's money

    var plan: Investment {
        Investment(name: "Your Plan",
                   monthlyDeposit: monthlyDeposit,
                   annualRatePercent: annualRate,
                   years: Int(years))
    }

    // Final value adjusted for inflation ("real" / today's-money value).
    var realValue: Double {
        plan.projectedValue / pow(1 + inflation / 100, years)
    }

    var body: some View {
        // NavigationStack gives us a title bar like real iOS apps have.
        NavigationStack {
            // ScrollView so nothing gets cut off on smaller iPhones.
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // --- The headline result card ---
                    VStack(alignment: .leading, spacing: 4) {
                        Text("In \(Int(years)) years you'd have")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(plan.projectedValue.rupees)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.green)
                        Text("≈ \(realValue.rupees) in today's money")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // --- Deposit vs growth ---
                    HStack(spacing: 24) {
                        labelValue(label: "You put in", value: plan.totalDeposited.rupees)
                        labelValue(label: "Growth", value: plan.growth.rupees)
                    }

                    // --- Plain-language insight: the "why it matters" line ---
                    Text(plan.insight)
                        .font(.callout)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    // --- The live chart ---
                    GrowthChartView(plan: plan)

                    Divider()

                    // --- The interactive controls ---
                    Text("Adjust your plan")
                        .font(.headline)

                    sliderRow(title: "Monthly saving",
                              value: "₹\(Int(monthlyDeposit))",
                              binding: $monthlyDeposit, range: 500...50000, step: 500)

                    sliderRow(title: "Expected return",
                              value: "\(String(format: "%.1f", annualRate))% / year",
                              binding: $annualRate, range: 1...20, step: 0.5)

                    sliderRow(title: "Years invested",
                              value: "\(Int(years)) yrs",
                              binding: $years, range: 1...40, step: 1)

                    sliderRow(title: "Inflation",
                              value: "\(String(format: "%.1f", inflation))% / year",
                              binding: $inflation, range: 0...12, step: 0.5)
                }
                .padding()
            }
            .navigationTitle("FinLit")
        }
    }

    // A label with a value underneath — used for the two facts.
    func labelValue(label: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title3).bold()
        }
    }

    // One reusable slider row: a title, the current value, and the slider.
    // `binding` uses `$` — a two-way link so the slider can READ and WRITE the state.
    func sliderRow(title: String, value: String,
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

// The app's ROOT: a tab bar that switches between the two screens.
// FinLitApp.swift shows this first.
struct ContentView: View {
    var body: some View {
        TabView {
            PlanView()
                .tabItem { Label("Plan", systemImage: "chart.line.uptrend.xyaxis") }
            CompareView()
                .tabItem { Label("Compare", systemImage: "arrow.left.arrow.right") }
            GoalView()
                .tabItem { Label("Goal", systemImage: "target") }
        }
    }
}

#Preview {
    ContentView()
}
