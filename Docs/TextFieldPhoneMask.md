# TextField Phone Mask

## Purpose

`DSPhoneMaskModifier` centralizes phone number formatting for `TextField` in DesignSystem.

## Why It Lives in DesignSystem

- Avoids duplicating masking logic across feature views.
- Keeps view models focused on domain and async flows.
- Keeps SwiftUI views focused on composition and presentation.

## Formatting Rules

- Keeps only numeric characters.
- Limits input to 11 digits.
- Applies `(##) #####-####` formatting as the user types.

## Usage

Apply the modifier on a `TextField` with the same binding used by the field:

```swift
TextField("(11) 99999-9999", text: $viewModel.phoneNumber)
    .dsPhoneMask($viewModel.phoneNumber)
```
