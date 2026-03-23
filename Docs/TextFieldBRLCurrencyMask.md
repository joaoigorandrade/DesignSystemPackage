# TextField BRL Currency Mask

## Purpose

`DSBRLCurrencyMaskModifier` keeps a `TextField` formatted as Brazilian real while the user types.

## Why It Lives in DesignSystem

- Avoids duplicating currency formatting logic across feature views.
- Keeps view models focused on parsing and submission logic.
- Keeps SwiftUI views focused on composition and presentation.

## Formatting Rules

- Keeps only numeric characters.
- Interprets the typed digits as cents.
- Formats the value using `pt_BR` currency rules with the `R$` symbol.
- Clears the field when all digits are removed.

## Usage

Apply the modifier on a `TextField` or `DSTextField` with the same binding used by the field:

```swift
DSTextField(
    placeholder: "R$ 100,00",
    text: $viewModel.initialPoolCentsText,
    keyboardType: .numberPad
)
.dsBRLCurrencyMask($viewModel.initialPoolCentsText)
```
