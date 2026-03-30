# DSHaptics

`DSHaptics` centralizes app haptic behavior using CoreHaptics.

## Public API

- `DSHapticEvent`: semantic events (`tapPrimary`, `tapSecondary`, `selection`, `success`, `error`, `warning`)
- `DSHapticPattern`: custom pattern definition using one or more segments and optional control-point curve
- `DSHapticConfiguration`: event-to-pattern mapping with override support
- `DSHaptics`: service with:
  - `play(event:)`
  - `play(pattern:)`
  - `configure(_:)`

## Default Event Mapping

- `tapPrimary`: medium transient pulse
- `tapSecondary`: light transient pulse
- `selection`: light crisp transient pulse
- `success`: two short pulses with rising intensity
- `error`: two sharper pulses
- `warning`: one sharper pulse

## Override Example

```swift
import DesignSystem

var config = DSHapticConfiguration.default
config.setPattern(
    .pulse(intensity: 0.6, sharpness: 0.7, duration: 0.08),
    for: .selection
)
DSHaptics.shared.configure(config)
```

## SwiftUI Usage

Use `DSHaptics.shared.play(event:)` in action handlers and `onChange` blocks for state-based feedback.
