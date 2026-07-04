# FinLit — Making Investing Make Sense

An iOS app that turns abstract investing concepts into something you can *see* and *feel* — built with SwiftUI and Swift Charts.

---

## Why I built this

For a while, my friends and I informally helped people around us — family, classmates — make sense of their investments. We even gave it a name: **NerdHoldings**. It was never an app or a company; it was us, sitting with one person at a time, explaining things like *"why does putting in a little every month matter so much later?"*

The same questions came up again and again, and the honest answer was almost always the same: **compounding**. But compounding is hard to *feel* when it's just a formula. A number on its own — "you'll have ₹11 lakh" — doesn't land. A curve that visibly bends upward does.

FinLit is my attempt to take that one-person-at-a-time explanation and turn it into something that scales: an app that lets anyone plug in what they can save and *watch* what it becomes.

## What it does

- Takes a simple input — how much you save per month, an expected return, and how long — and projects the outcome.
- Splits the result into **what you put in** vs. **growth from returns**, so the effect of compounding is explicit.
- Draws a year-by-year **growth curve** that visibly accelerates — the whole point being that the shape teaches the lesson better than any sentence.

## How it's built (and why)

The project is deliberately split into two layers:

| Layer | File | Responsibility |
|-------|------|----------------|
| **Engine** | `Investment.swift` | All the math — projection, deposit vs. growth split, and the year-by-year data. Pure Swift, no UI. |
| **Interface** | `ContentView.swift`, `GrowthChartView.swift` | SwiftUI screens that *display* the engine's output. No math lives here. |

**Why separate them?** The engine has no idea a screen exists — which means the exact same logic can be tested on its own, reused elsewhere, or wrapped in a completely different UI later. Keeping calculation and presentation apart is a habit I picked up deliberately, not an accident of where code landed.

Other decisions:
- **Swift Charts, not a third-party library.** The growth curve uses Apple's native charting framework — no external dependencies to install or maintain.
- **Native SwiftUI components throughout.** Using system text styles (`.largeTitle`, `.headline`, etc.) means the app inherits Dynamic Type and VoiceOver support by default, rather than fighting the platform for accessibility.
- **Composable views.** Repeated pieces (like the label-and-value pairs, and the chart) are their own small views, dropped into the main screen — so nothing is copy-pasted.

## Tech stack

- **Swift** — application logic and the projection engine
- **SwiftUI** — declarative UI
- **Swift Charts** — the growth visualization
- No third-party dependencies

## Status & roadmap

**Working now:**
- [x] Projection engine (total value, deposit-vs-growth split, yearly data points)
- [x] Home screen showing the headline result
- [x] Growth-over-time chart

**Next:**
- [ ] Let the user adjust the inputs live (sliders) and watch the curve respond
- [ ] Compare two scenarios side by side (e.g. "start at 22 vs. start at 30")
- [ ] Plain-language explanations attached to each result
- [ ] An explicit accessibility pass (VoiceOver labels, larger-text testing)

## What I learned

This is an early project and I'm new to Swift — I'm documenting that honestly. Building it taught me how a SwiftUI view is structured (`body`, stacks, composing small views), how `ForEach` drives both data loops and chart marks, and — the part I care about most — why separating logic from UI makes an app easier to reason about. The next projects build on exactly these ideas.

---

*Built by Milap Kothari.*
