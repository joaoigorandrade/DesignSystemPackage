# BrandDesignSystem

A lightweight, purely SwiftUI-based design system tailored for iOS, supporting features like dark mode, Dynamic Type, SF Symbols, and standardized view states. This framework adheres to Apple's Human Interface Guidelines.

## Features

- **Colors & Tokens**: Standardized semantic roles such as `brandPrimary`, `success`, `danger`, `warning`, `vibrantOrange`, `coolGrey`, and `backgroundGrey`.
- **Automatic Dark Mode**: Color sets automatically adapt to light and high-contrast dark environments.
- **Typography**: Complete reliance on San Francisco (SF Pro) via `.system` fonts and Dynamic Type scaling extensions `dsHeadline()`, `dsBody()`.
- **Standard State Handling**: Native enum-driven (`ViewState`) state representation extending consistently to inputs, buttons, and overarching view layers.
- **Liquid Glass Design Language**: Embrace depth, translucency, and hierarchy utilizing `ultraThinMaterial` on components like `DSCard`.

## Installation

Integrate using Swift Package Manager (SPM). Add this package dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/BrandDesignSystem.git", from: "1.0.0")
]
```

Or add it from Xcode via **File > Add Packages...**.

## Documentation

Review the external documentation for extensive guidelines on the standard state architecture and component references:
- [Usage Guidelines](Docs/Usage.md)
