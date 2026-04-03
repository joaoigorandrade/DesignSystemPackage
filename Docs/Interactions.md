# Interaction Models, Haptics & Accessibility

## 1. Haptic Feedback

The system exposes `DSHaptics.shared.play(event:)` backed by Core Haptics.
All rules below reference `DSHapticEvent` cases.

### Event Semantics

| Event | Intensity / Sharpness | Feel | When to use |
|---|---|---|---|
| `tapPrimary` | 0.55 / 0.45 | Medium, slightly soft | Primary `DSButton` tap; any high-confidence action |
| `tapSecondary` | 0.35 / 0.35 | Light, rounded | `FABView` open/close; icon-only nav bar buttons; non-destructive row taps |
| `selection` | 0.35 / 0.50 | Light, crisp | `DSSwitch` toggle; picker selection; `FABView` action item tap |
| `success` | 0.5→0.7 / 0.4→0.55 | Two-pulse ascent | `ViewState.success` on `DSButton` or `DSTextField`; async operation resolved positively |
| `error` | 0.85→0.7 / 0.75→0.90 | Sharp double-strike | `ViewState.error` on `DSButton` or `DSTextField`; form validation failure |
| `warning` | 0.80 / 0.85 | Single sharp pop | Disabled action attempt; `FABView` item that has a tooltip error |

### Component → Haptic Mapping

```
DSButton
  ├── On tap (idle)          → tapPrimary   (.destructive style: tapPrimary)
  ├── State → .success       → success      (automatic via stateHapticsEnabled)
  └── State → .error         → error        (automatic via stateHapticsEnabled)

DSTextField
  ├── State → .error         → error        (caller is responsible)
  └── State → .success       → success      (caller is responsible)

DSSwitch
  └── Toggle                 → selection

FABView
  ├── Open / close trigger   → tapSecondary
  ├── Action item tap        → selection    (then collapsed silently)
  └── Disabled item tap      → warning      (shows tooltip)

DSNavBarButton
  └── Tap                    → tapSecondary (caller implements)

DSListRow / custom rows
  └── Tap                    → tapSecondary (caller implements)
```

### Rules

- **Never chain haptics** within 100 ms of each other — the engine cannot render overlapping transients distinctly.
- **Disable haptics on disabled controls.** `DSButton` and `FABView` already guard this; maintain the pattern everywhere.
- **Do not play haptics in response to scroll position, animations, or automatic state polling.** Haptics are always user-initiated or the direct result of a network/async outcome.
- **Respect `UIAccessibility.isReduceMotionEnabled`.** Haptics are unaffected by reduce-motion, but if reduce-motion is on, skip any haptic that is purely decorative (i.e., `tapSecondary` on scroll snapping). Keep semantic haptics (`success`, `error`, `warning`) active regardless.
- **No haptics on `.loading` state entry.** Loading is an intermediate state with no user outcome yet.

---

## 2. Animation Curves & Timings

All animations must use `spring` unless noted. The values below are the canonical reference; deviations require a documented reason.

### Spring Parameter Vocabulary

| Name | `response` | `dampingFraction` | Character | Use case |
|---|---|---|---|---|
| **Snappy** | 0.25 | 0.80 | Fast, tight, no bounce | Chip selections, badge updates, counter increments |
| **Standard** | 0.30 | 0.70 | Balanced, minimal bounce | `DSTextField` focus ring, `DSButton` state change |
| **Expressive** | 0.32–0.35 | 0.65–0.72 | Slight overshoot | `DSSwitch` thumb, `FABView` expand, press scale |
| **Reveal** | 0.40 | 0.75 | Smooth entry, gentle settle | Sheet presentation, card entrance, modal overlay |
| **Gentle** | 0.50 | 0.85 | Slow, barely perceptible | Background color crossfades, opacity fades |

### Per-Component Specification

#### `DSButton`
```
Press scale (0.96) + shadow reduction  →  .spring(response: 0.30, dampingFraction: 0.60)
State transition (.loading / .success / .error)  →  .spring(response: 0.30, dampingFraction: 0.70)
```
> The existing `.easeInOut(duration: 0.2)` on state/disabled changes should be migrated to the Standard spring to stay consistent. Track in backlog.

#### `DSTextField`
```
Focus ring + scale (1.01) + glow       →  .spring(response: 0.32, dampingFraction: 0.65)
State icon transition (.scale + .opacity)  →  .spring(response: 0.30, dampingFraction: 0.70)
Clear button text wipe                  →  .spring(response: 0.20, dampingFraction: 0.75)
Error/helper text slide-in (.opacity + .move(edge: .top))  →  .spring(response: 0.28, dampingFraction: 0.72)
```

#### `DSSwitch`
```
Thumb translation + track color         →  .spring(response: 0.28, dampingFraction: 0.72)
```

#### `FABView`
```
Expand/collapse + rotation (0°→45°)     →  .spring(response: 0.35, dampingFraction: 0.75)
Backdrop opacity                        →  .spring(response: 0.35, dampingFraction: 0.75)  [same transaction]
Action rows stagger (if added)          →  delay each row by 0.04 s × index
Tooltip appear                          →  .spring(response: 0.25, dampingFraction: 0.80)
```

#### `DSNavigationBar`
```
inline ↔ large transition (title scale/opacity)  →  .spring(response: 0.35, dampingFraction: 0.80)
```

#### Screen / Sheet Transitions
```
Push (trailing → leading)               →  .spring(response: 0.42, dampingFraction: 0.82)
Pop  (leading → trailing)               →  .spring(response: 0.38, dampingFraction: 0.85)
Modal sheet present (bottom → up)       →  .spring(response: 0.45, dampingFraction: 0.78)
Modal sheet dismiss (up → bottom)       →  .spring(response: 0.38, dampingFraction: 0.88)
Alert / toast appear                    →  .spring(response: 0.30, dampingFraction: 0.72)
```

### `withAnimation` vs `.animation(_, value:)`
- Use `.animation(_:value:)` on the view that changes — not `withAnimation` wrapped around a binding assignment — unless multiple unrelated views must animate together in one transaction.
- Never use `.animation(.default)` or `.animation(nil)` — always name the curve explicitly.

### Reduce Motion
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// Pattern to apply everywhere motion is non-trivial:
.animation(reduceMotion ? .linear(duration: 0.1) : .spring(response: 0.35, dampingFraction: 0.75), value: isExpanded)
```
- **Fade is always acceptable** as the reduce-motion fallback (`.opacity`).
- **Never fully skip the animation** — a zero-duration snap causes jarring layout jumps for users with vestibular disorders.
- Scale effects (`scaleEffect`) and translation (`offset`, `move`) must be replaced or removed when `reduceMotion` is true.

---

## 3. Accessibility Guidelines

### Minimum Touch Targets
- Interactive controls: **44 × 44 pt** minimum (already enforced in `DSNavigationBar` leading/trailing slots and `DSNavBarButton`).
- `DSSwitch` thumb area must be padded with `.contentShape` to reach 44 × 44 pt even though the visual size is 25 × 16 pt.
- `FABView` trigger: 56 × 56 pt — already compliant.

### `accessibilityLabel`
```
DSButton        →  title (automatic from Text)
DSSwitch        →  label describing what is controlled, not the state
                   e.g. "Pool notifications" not "Switch"
FABView trigger →  "Open actions" / "Close actions"  ✓ already implemented
FABView rows    →  item.title  (automatic from Text)
DSNavBarButton  →  describe the action: "Back", "Search", "Profile"
DSTextField     →  label value (if provided); otherwise placeholder
```

### `accessibilityValue`
```
DSSwitch  →  "On" / "Off"  (use .accessibilityValue(isOn ? "On" : "Off"))
DSProgressView  →  formatted percentage string
DSTextField with characterLimit  →  "\(text.count) of \(limit) characters"
```

### `accessibilityHint`
Use sparingly — only when the action's result is non-obvious from the label alone.
```
FABView trigger (collapsed)  →  "Opens a menu with available actions"
DSTextField (password)       →  "Double-tap to show or hide password"
```

### `accessibilityTrait`
```
DSButton (.primary / .destructive)  →  .isButton  (automatic)
DSButton (state == .loading)        →  add .updatesFrequently
DSButton (state == .success)        →  add .staticText temporarily, remove .isButton
DSSwitch                            →  .isButton + announce new state via UIAccessibility.post(notification: .announcement)
```

### `accessibilityAction`
Custom actions for compound components:
```swift
// DSTextField — expose "Clear" action instead of relying solely on the visible button
.accessibilityAction(named: "Clear") { text = "" }

// FABView — expose each item as an action on the trigger button when collapsed
.accessibilityAction(named: item.title) { item.action() }
```

### Dynamic Type
- All text uses design system typography modifiers (`dsHeadline()`, `dsBody()`, etc.) — these must be backed by `Font` values that respect the user's preferred content size category.
- Never hard-code `.font(.system(size: 14))` without `.relativeTo` or a scaled font.
- Test all components at **AX5** (largest accessibility size) — layouts must reflow, not clip.
- `DSButton` with `.tertiary` style: allow `.fixedSize(horizontal: false, vertical: true)` to wrap title across lines at AX sizes.

### Color Contrast
| Pair | Minimum ratio |
|---|---|
| `textPrimary` on `backgroundBase` | 4.5 : 1 (AA) |
| `textSecondary` on `backgroundBase` | 4.5 : 1 (AA) |
| `textTertiary` on `backgroundBase` | 3.0 : 1 (AA Large — used for captions only) |
| White on `brandPrimary` (`DSButton` label) | 4.5 : 1 (AA) |
| White on `danger` (`DSButton` destructive label) | 4.5 : 1 (AA) |

Verify both light and dark mode asset variants in `Assets.xcassets` satisfy these ratios.

### Focus Order (`accessibilitySortPriority`)
- Navigation bar: leading → title → trailing, top to bottom.
- Form screens: label → input → helper/error, then next field.
- `FABView` when expanded: trigger → action rows top to bottom.
- Do not use `.accessibilityHidden(true)` on decorative icons that are siblings of a labeled control — they are already hidden automatically if the parent carries a label.

### VoiceOver Announcements for Async State Changes
```swift
// After state transitions in callers (not inside components):
.onChange(of: viewState) { _, newState in
    switch newState {
    case .success:
        UIAccessibility.post(notification: .announcement, argument: "Done")
    case .error(let message):
        UIAccessibility.post(notification: .announcement, argument: message)
    default:
        break
    }
}
```
Components themselves do not post announcements — the caller owns the semantics.
