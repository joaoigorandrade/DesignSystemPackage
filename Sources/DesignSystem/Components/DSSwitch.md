# DSSwitch

`DSSwitch` is a reusable, brand-aligned switch control for settings and preference screens.

## API

- `isOn`: external `@Binding` that stores the switch state
- `isEnabled`: disables interaction and reduces visual emphasis
- `accessibilityLabel`: custom spoken label for VoiceOver

## Behavior

- Uses a pill-shaped track with a circular thumb
- Animates the thumb with a spring transition
- Renders as a compact standalone control
- Uses Design System colors only

## Example

```swift
@State private var notificationsEnabled = true

DSSwitch(
    isOn: $notificationsEnabled,
    accessibilityLabel: "Notifications"
)
```
