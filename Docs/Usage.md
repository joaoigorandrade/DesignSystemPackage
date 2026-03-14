# BrandDesignSystem: Usage Guidelines

## Components

### DSButton

Used to trigger an action. 

```swift
DSButton(
    title: "Continue",
    icon: .chevronRight, 
    style: .primary, 
    state: .idle
) {
    // Action
}
```

### DSTextField

A customized input field bound to standard states.

```swift
@State private var email = ""

DSTextField(
    placeholder: "Email Address",
    text: $email,
    state: .idle
)
```

### DSCard

A highly composable view enforcing rounded geometries and optional "Liquid Glass" rendering.

```swift
DSCard(useLiquidGlass: true) {
    VStack {
        Text("Glass Card Content")
    }
}
```

### State Management Modifiers

Using `dsState(_ state: ViewState)` wraps an entire view with contextual alerts, loadings, or error banners based on the passed state.

```swift
VStack {
    Text("Content")
}
.dsState(.loading)
```

## Typography

Utilize the pre-built typography extensions to guarantee adherence to system accessibility sizing routines.

```swift
Text("Headline Text")
    .dsHeadline()

Text("Detailed supportive descriptive content.")
    .dsBody()
```
