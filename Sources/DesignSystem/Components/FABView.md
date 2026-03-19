# FABView

`FABView` is a reusable floating action button that expands into contextual actions.

## API

- `isExpanded`: external `@Binding` that controls expanded/collapsed state
- `actionItems`: array of pre-factored `FABActionItem` values
- Pre-factored constructors: `.challenge(state:action:)`, `.expense(state:action:)`, `.withdrawal(state:action:)`

## Behavior

- Renders as a circular `+` button anchored to bottom-right
- Expands into three options: `Challenge`, `Expense`, `Withdrawal`
- Uses spring animation for open/close transitions
- Dismisses when tapping outside or swiping down on backdrop
- Disabled actions use `coolGrey` styling
- Disabled actions can surface tooltip guidance text

## Example

```swift
struct FABHostView: View {
    @State private var isExpanded = false

    var body: some View {
        ZStack {
            Color.backgroundGrey.ignoresSafeArea()

            FABView(
                isExpanded: $isExpanded,
                actionItems: [
                    .challenge { },
                    .expense(state: .error("Expense feature requires manager approval.")) { },
                    .withdrawal { }
                ]
            )
        }
    }
}
```
