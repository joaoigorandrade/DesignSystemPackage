# Groupool iOS Design System — Documentation

Welcome to the Groupool Design System. This directory contains the complete specification, implementation guide, and QA checklist for iOS component development.

---

## Documentation Index

### 1. **[COMPONENTS.md](COMPONENTS.md)** — Component Implementation Guide
**For:** Developers building features with design system components.

Covers:
- When to use / when NOT to use each component
- Complete interface specifications
- Styling rules and color mappings
- State behavior and haptic feedback
- Animation constraints
- Accessibility requirements
- Code examples for all 11 components

Start here when building UI.

---

### 2. **[Atoms.md](Atoms.md)** — Design Tokens
**For:** Everyone. Reference for colors, typography, spacing, and corner radii.

Contains:
- Color palette (brand, semantic, backgrounds, text, borders)
- Typography scale (11 levels, weights, leading)
- Spacing grid (base units, corner radii, touch targets)
- WCAG AAA contrast matrix
- iOS semantic mappings

**Quick reference:** Use `DSSpacing.space16`, `Color.brandPrimary`, `Text.dsHeadline()`.

---

### 3. **[Interactions.md](Interactions.md)** — Motion, Haptics & Accessibility
**For:** Developers and designers concerned with motion, haptics, and accessible interactions.

Covers:
- Haptic events and component-to-haptic mapping
- Spring animation curves (snappy, standard, expressive, reveal, gentle)
- Reduce Motion support patterns
- Accessibility guidelines (touch targets, labels, VoiceOver, keyboard navigation)
- Dynamic Type support (test at AX5)

---

### 4. **[QA_CHECKLIST.md](QA_CHECKLIST.md)** — Testing & Code Review
**For:** QA engineers, code reviewers, and developers verifying component implementation.

Includes:
- Pre-implementation architecture review
- Per-component implementation checklist (DSButton, DSTextField, DSAvatar, etc.)
- Cross-component validation (colors, typography, spacing, haptics, animations)
- Accessibility testing (VoiceOver, Reduce Motion, text sizes)
- Live device testing protocol
- Sign-off section

Use during code review and before shipping.

---

## Quick Start

### Adding a Component to a Screen

1. **Check what exists:** Open [COMPONENTS.md](COMPONENTS.md) and find your component.
2. **Read "When to Use":** Verify it's the right component for your use case.
3. **Copy the code example:** Use the provided Swift snippet as a starting point.
4. **Verify state handling:** Ensure you initialize state correctly (default `.idle`).
5. **Test accessibility:** Run through the checklist in [QA_CHECKLIST.md](QA_CHECKLIST.md).

---

## Design System Principles

### MVVM Architecture
- **View** ← View-only logic (layout, presentation)
- **ViewModel** ← Business logic, state, networking
- **Model** ← Data structures

Components enforce this: they have **zero** business logic.

### SOLID Principles
- **Single Responsibility:** Each component does one thing.
- **Open/Closed:** Components are extendable via modifiers, not modification.
- **Liskov Substitution:** All `ViewState` transitions are predictable.
- **Interface Segregation:** Components accept only necessary parameters.
- **Dependency Inversion:** Dependencies flow downward (parent → child).

### Accessibility First
- **WCAG AAA contrast** (7:1 minimum on all backgrounds)
- **44×44 pt touch targets** for all interactive elements
- **VoiceOver support** with semantic labels and announcements
- **Reduce Motion respect** — animations have graceful fallbacks
- **Dynamic Type** — test at AX5 (largest text size)

### Dark Mode Only
- All colors are optimized for dark mode (#000011 background).
- Do NOT use system colors (`.red`, `.blue`) — use design system colors.
- No light mode assets needed.

---

## Key Design System Components

| Component | Purpose | State Support |
|-----------|---------|----------------|
| `DSButton` | Call-to-action, 4 styles | ViewState (.idle/.loading/.success/.error) |
| `DSTextField` | Single-line text input | ViewState (.idle/.loading/.success/.error) |
| `DSAvatar` | User profile image | Loading state |
| `DSCard` | Grouped content container | None (stateless) |
| `DSSwitch` | Binary toggle | Enabled/disabled |
| `DSListRow` | List item with icon & label | None (stateless) |
| `DSProgressView` | Multi-step progress indicator | currentIndex (not ViewState) |
| `DSNavigationBar` | Screen header with buttons | None (stateless) |
| `DSAutoCarousel` | Auto-advancing image carousel | None (stateless) |
| `DSAvatarCropper` | Profile image crop tool | Loading state |

---

## Color Palette (Quick Reference)

### Brand
- `Color.brandPrimary` — Blue (#60A5FA), primary actions
- `Color.brandSecondary` — Purple (#A78BFA), secondary accent

### Semantic
- `Color.success` — Green (#34D399), positive states
- `Color.danger` — Red (#F87171), errors, destructive
- `Color.warning` — Yellow (#FBBF24), caution states
- `Color.info` — Cyan (#22D3EE), informational

### Backgrounds
- `Color.backgroundBase` — Deep dark (#000011), canvas
- `Color.backgroundElevated` — Lighter dark (#111122), cards
- `Color.backgroundTop` — Lightest dark (#1A1A2E), sheets/modals

### Text
- `Color.textPrimary` — White (#FFFFFF), headlines & body
- `Color.textSecondary` — Grey (#BBBBD0), subtitles
- `Color.textTertiary` — Darker grey (#AAAAC2), captions

### Borders
- `Color.borderDefault` — (#2A2A44), dividers
- `Color.borderSubtle` — (#1A1A30), subtle separators

---

## Typography (Quick Reference)

Use extension methods on `View`:

```swift
Text("Large Title").dsLargeTitle()    // 34pt, bold
Text("Title").dsTitle()                // 28pt, bold
Text("Headline").dsHeadline()          // 17pt, semibold
Text("Body").dsBody()                  // 17pt, regular
Text("Caption").dsCaption()            // 12pt, regular
```

All fonts scale with system accessibility settings (Dynamic Type).

---

## Spacing & Layout Grid

Base unit: **4pt** (8pt primary grid)

```swift
DSSpacing.space2        // 2pt — micro gaps
DSSpacing.space4        // 4pt — tight spacing
DSSpacing.space8        // 8pt — default inline
DSSpacing.space16       // 16pt — component padding
DSSpacing.space24       // 24pt — card padding
DSSpacing.space32       // 32pt — section gap
DSSpacing.space64       // 64pt — hero sections

DSRadius.small          // 8pt — buttons, chips
DSRadius.medium         // 12pt — cards, text fields
DSRadius.large          // 16pt — modals
DSRadius.full           // 32pt — pills, FABs
```

---

## State Management Pattern

All components using `ViewState`:

```swift
enum ViewState: Equatable {
    case idle              // Default, no action
    case loading           // Async operation in progress
    case success           // Operation completed
    case error(String)     // Operation failed with message
}
```

**Typical flow:**

```swift
@State private var formState: ViewState = .idle

// User taps button
DSButton(/* ... */, state: formState) {
    formState = .loading                    // Step 1: Show loading
    Task {
        do {
            _ = try await submitForm()       // Step 2: Do work
            formState = .success             // Step 3: Show success
            // After 2-3 sec, clear state
            try await Task.sleep(nanoseconds: 2_000_000_000)
            formState = .idle
        } catch {
            formState = .error(error.localizedDescription)  // Or error
        }
    }
}
```

---

## Common Mistakes to Avoid

### ❌ Wrong: Validation in Components
```swift
// DON'T do this inside a component
if email.count < 5 {
    return .error("Email too short")
}
```

### ✅ Right: Validation in ViewModel
```swift
// DO this in ViewModel
func validateEmail(_ email: String) -> ViewState {
    guard email.count >= 5 else {
        return .error("Email too short")
    }
    return .idle
}
```

---

### ❌ Wrong: Hardcoded Spacing
```swift
VStack(spacing: 15)
    .padding(20)
```

### ✅ Right: Use Design System Constants
```swift
VStack(spacing: DSSpacing.space16)
    .padding(DSSpacing.space20)
```

---

### ❌ Wrong: Hardcoded Fonts
```swift
Text("Hello")
    .font(.system(size: 14, weight: .semibold))
```

### ✅ Right: Use Typography Modifiers
```swift
Text("Hello")
    .dsHeadline()
```

---

### ❌ Wrong: System Colors
```swift
.foregroundColor(.red)
.foregroundColor(.blue)
```

### ✅ Right: Design System Colors
```swift
.foregroundColor(.danger)
.foregroundColor(.brandPrimary)
```

---

## Testing Checklist (Quick)

Before shipping a feature using design system components:

- [ ] All text uses design system typography (`.dsHeadline()`, `.dsBody()`, etc.)
- [ ] All colors use design system colors (`.brandPrimary`, `.danger`, etc.)
- [ ] All spacing uses `DSSpacing` and `DSRadius` constants
- [ ] Components have correct state initialization
- [ ] Haptics play at appropriate times (user taps, state change)
- [ ] Animations use `.spring()` (not `.easeInOut()`)
- [ ] All interactive elements are 44×44 pt min touch target
- [ ] Text scales correctly at AX5 (largest accessibility size)
- [ ] Tested with VoiceOver enabled (all content reachable, labeled)
- [ ] Tested with Reduce Motion enabled (no janky animations)

See [QA_CHECKLIST.md](QA_CHECKLIST.md) for comprehensive testing protocol.

---

## File Structure

```
@Groupool/Packages/DesignSystem/
├── Sources/DesignSystem/
│   ├── Components/               ← All UI components
│   │   ├── DSButton.swift
│   │   ├── DSTextField.swift
│   │   ├── DSAvatar.swift
│   │   ├── DSCard.swift
│   │   ├── DSSwitch.swift
│   │   ├── DSListRow.swift
│   │   ├── DSProgressView.swift
│   │   ├── DSNavigationBar.swift
│   │   ├── DSAutoCarousel.swift
│   │   ├── DSAvatarCropper.swift
│   │   └── FABView.swift (legacy)
│   ├── Tokens/                   ← Design tokens
│   │   ├── Color+DesignSystem.swift
│   │   ├── Typography+DesignSystem.swift
│   │   ├── Spacing+DesignSystem.swift
│   │   ├── ViewState.swift
│   │   └── BrandIcon.swift
│   ├── Resources/
│   │   └── Assets.xcassets/      ← Color sets, images
│   └── Previews/
│       └── DesignSystemPreviews.swift
├── Docs/                         ← Documentation
│   ├── README.md                 ← You are here
│   ├── COMPONENTS.md             ← Component guide
│   ├── Atoms.md                  ← Design tokens
│   ├── Interactions.md           ← Motion, haptics, a11y
│   └── QA_CHECKLIST.md           ← Testing guide
└── Package.swift
```

---

## Support & Feedback

- **Found a bug?** Update the component in `Sources/` and test per [QA_CHECKLIST.md](QA_CHECKLIST.md).
- **Want to add a component?** Document it in [COMPONENTS.md](COMPONENTS.md) first, then implement.
- **Questions on usage?** Check the "Example" section in [COMPONENTS.md](COMPONENTS.md).
- **Need to update tokens?** Edit `Tokens/` files, then update [Atoms.md](Atoms.md) and color swatches.

---

## Design System Governance

- **Owner:** Design Systems Team
- **Approvers:** Design Systems Lead, iOS Tech Lead
- **Review Process:** Code review + [QA_CHECKLIST.md](QA_CHECKLIST.md) sign-off
- **Breaking Changes:** Require migration guide + version bump in `Package.swift`
- **New Components:** Documented in [COMPONENTS.md](COMPONENTS.md) + added to `DesignSystemPreviews.swift` before merge

---

**Last updated:** 2026-04-02
**Version:** 1.0 (iOS 15+)
**Maintained by:** Design Systems Team
