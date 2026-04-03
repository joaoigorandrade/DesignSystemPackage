# Groupool Design System — Components

## Overview

This document specifies component behavior, constraints, and implementation rules for the iOS design system. All components enforce SOLID principles, MVVM architecture, and respect the token definitions in `Atoms.md`.

---

## 1. DSButton

**Purpose:** Trigger an action with immediate visual feedback and haptic confirmation.

### When to Use

- Primary calls-to-action (primary style)
- Secondary, lower-priority actions (secondary style)
- Subtle, text-only actions (tertiary style)
- Destructive actions requiring confirmation (destructive style)

### When NOT to Use

- Do NOT use for navigation — use `DSNavigationBar` with proper navigation stack
- Do NOT nest buttons inside buttons
- Do NOT use for toggles — use `DSSwitch` instead
- Do NOT use for radio/checkbox groups — create dedicated component

### Interface

```swift
struct DSButton: View {
    let title: String
    let icon: BrandIcon?
    let style: DSButtonStyle          // .primary | .secondary | .tertiary | .destructive
    let state: ViewState              // .idle | .loading | .success | .error(String)
    let isDisabled: Bool
    let tapHaptic: DSHapticEvent?     // default: .tapPrimary
    let stateHapticsEnabled: Bool     // default: true
    let action: () -> Void
}

enum DSButtonStyle {
    case primary              // brandPrimary bg, white text, full width
    case secondary            // transparent bg, bordered, brandPrimary text
    case tertiary             // transparent bg, no border, brandPrimary text, fixed width
    case destructive          // danger bg, white text, full width
}
```

### Styling Rules

| Style | Background | Text Color | Border | Width | Use Case |
|-------|-----------|-----------|--------|-------|----------|
| `.primary` | `brandPrimary` | white | `brandPrimary` (hidden) | Full | Main action, always available |
| `.secondary` | Transparent | `brandPrimary` | `borderDefault` (1.5pt) | Full | Alternative action, form submission |
| `.tertiary` | Transparent | `brandPrimary` | None | Intrinsic | Dismiss, cancel, skip, minor actions |
| `.destructive` | `danger` | white | `danger` (hidden) | Full | Delete, logout, confirm loss |

### State Behavior

- **`.idle`**: Fully interactive, shadow visible
- **`.loading`**: Disabled, spinner centered where icon/text was, haptics disabled
- **`.success`**: Disabled, checkmark icon, haptic feedback plays, state persists until parent clears
- **`.error(String)`**: Disabled, error haptic plays, caller must render error message separately (not in button)

### Haptic Mapping

| Event | Trigger |
|-------|---------|
| `tapPrimary` | User tap (primary/destructive style) |
| `tapSecondary` | User tap (secondary/tertiary style) |
| `success` | State transitions to `.success` (if `stateHapticsEnabled == true`) |
| `error` | State transitions to `.error(_)` (if `stateHapticsEnabled == true`) |

### Animation Constraints

- Press scale: `0.96` on tap
- Shadow reduction on press
- State transitions use `.spring(response: 0.3, dampingFraction: 0.7)`
- Icon swap (loading → checkmark) uses `.scale.combined(with: .opacity)`

### Implementation Notes

- **Icon + title:** HStack with `DSSpacing.space8` gap
- **Icon-only buttons:** Not supported — use `DSNavigationBar` button slots
- **Disabled color:** `coolGrey.opacity(0.3)` background
- **Min touch target:** 44×44 pt (automatically enforced by padding + min height)

### Example

```swift
@State private var submitState: ViewState = .idle

DSButton(
    title: "Transfer",
    icon: .arrowRight,
    style: .primary,
    state: submitState,
    isDisabled: form.isEmpty
) {
    submitState = .loading
    Task {
        do {
            _ = try await transferFunds(form)
            submitState = .success
        } catch {
            submitState = .error(error.localizedDescription)
        }
    }
}
```

---

## 2. DSTextField

**Purpose:** Single-line text input with state feedback, formatting, and keyboard type selection.

### When to Use

- Email, password, numeric input
- Any form field with label and optional error/helper text
- Fields requiring character limits
- Phone/currency input with modifiers

### When NOT to Use

- Do NOT use for multi-line text — implement custom TextEditor
- Do NOT use for search input in a list — create `DSSearchField`
- Do NOT hardcode masks — the field accepts plain text; apply masks via view modifiers
- Do NOT embed in sheets without focus management

### Interface

```swift
struct DSTextField: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let state: ViewState
    let helperText: String?
    let characterLimit: Int?
    let isSecure: Bool
    let keyboardType: UIKeyboardType      // default: .default
    let textContentType: UITextContentType?
    let autocapitalization: TextInputAutocapitalization
    let autocorrectionDisabled: Bool
    let onSubmit: () -> Void
}
```

### Styling Rules

| Element | Color / Style |
|---------|---------------|
| Label (idle) | `textSecondary`, `dsCallout` weight |
| Label (focused) | `brandPrimary`, `dsCallout` weight |
| Label (error) | `danger`, `dsCallout` weight |
| Placeholder | `textTertiary`, `dsBody` |
| Input text | `textPrimary`, `dsBody` |
| Background | `glassEffect` with rounded corners (`radiusMedium`) |
| Border (idle) | `borderDefault`, 1pt |
| Border (focused) | `brandPrimary`, 2.5pt |
| Border (error) | `danger`, 2.5pt |
| Border (success) | `success`, 2.5pt |
| Shadow (focused) | `brandPrimary.opacity(0.25)`, 8pt radius |
| Helper text | `textTertiary`, `dsCaption` |
| Error text | `danger`, `dsCaption` |
| Character count | `textTertiary` (or `danger` if over limit) |

### Validation Flow

```
1. User types                 → Check characterLimit (if set)
2. Over limit?                → Show counter in red
3. onSubmit triggered?        → Caller validates, sets state to .error or .success
4. State change triggers      → Border color & icon update with animation
```

**NOTE:** The field does NOT validate — it only displays state. Validation logic belongs in the ViewModel/caller.

### State Behavior

- **`.idle`**: Default appearance, clear button appears on focus (non-secure fields only)
- **`.loading`**: Spinner replaces input status area, field disabled
- **`.success`**: Checkmark icon, field disabled, remains visible until parent clears state
- **`.error(String)`**: Error icon, field disabled, error message shown below field

### Focus & Accessibility

- **Clear button:** Appears on focus when text is not empty and field is not secure
- **Focus ring:** Applies `scaleEffect(1.01)` with spring animation
- **Glow:** Shadow expands on focus
- **`@FocusState`:** Manages focus via private state — do not expose focus binding to caller

### Character Limit

If `characterLimit` is set:
- Input is clamped to limit (caller input is truncated client-side)
- Counter displays `text.count / limit` in footer
- Counter turns red if `text.count > limit`

### Keyboard Configuration

```swift
// Phone number
DSTextField(
    label: "Mobile",
    placeholder: "(11) 99999-9999",
    text: $phone,
    keyboardType: .phonePad,
    textContentType: .telephoneNumber
)

// Email
DSTextField(
    label: "Email",
    placeholder: "user@example.com",
    text: $email,
    keyboardType: .emailAddress,
    textContentType: .emailAddress,
    autocorrectionDisabled: true
)

// Password
DSTextField(
    label: "Password",
    placeholder: "Enter password",
    text: $password,
    isSecure: true,
    textContentType: .password,
    autocapitalization: .none,
    autocorrectionDisabled: true
)
```

### Implementation Notes

- **Glass effect:** Uses SwiftUI's `.glassEffect()` modifier (must be available in project)
- **Padding:** 16pt horizontal, 15pt vertical inside field
- **Status icon width:** 48pt + 4pt trailing margin
- **Transition:** Status icon uses `.scale.combined(with: .opacity)`
- **Min touch target:** Automatically 44×44 pt due to padding

### Example

```swift
@State private var email = ""
@State private var emailState: ViewState = .idle

DSTextField(
    label: "Email Address",
    placeholder: "you@example.com",
    text: $email,
    state: emailState,
    helperText: "We'll verify this during signup",
    keyboardType: .emailAddress,
    textContentType: .emailAddress
)
.onChange(of: email) { _, newValue in
    // No validation here — wait for form submission
}
```

---

## 3. DSAvatar

**Purpose:** Display user profile image with fallback to initials in a circular frame.

### When to Use

- User profile pictures in cards, lists, headers
- Thread participants
- Account selectors
- Any circular profile image context

### When NOT to Use

- Do NOT use as a tap target by itself — wrap in a Button with proper accessibility
- Do NOT use for non-user imagery (use Image directly)
- Do NOT customize shape — it is always circular

### Interface

```swift
struct DSAvatar: View {
    let avatarURL: URL?
    let previewImage: UIImage?
    let initials: String
    let size: DSAvatarSize
    let isLoading: Bool = false
}

enum DSAvatarSize {
    case small      // 44pt
    case medium     // 72pt
    case large      // 112pt
    case custom(CGFloat)
}
```

### Sizing & Typography

| Size | Diameter | Text Font |
|------|----------|-----------|
| `.small` | 44pt | `dsCaption` |
| `.medium` | 72pt | `dsCallout` |
| `.large` | 112pt | `dsTitle` |
| `.custom(n)` | n pt | Auto-selected based on size |

### Content Priority

1. `previewImage` (local UIImage, usually from image picker)
2. `avatarURL` (remote URL, loaded via Kingfisher)
3. `initials` (fallback, shown if URL fails or no URL provided)

If URL fails to load, the component automatically falls back to initials without any error state.

### Background

- Default circle fill: `brandPrimary.opacity(0.15)`
- Initials text: `brandPrimary`, bold

### Loading State

When `isLoading == true`:
- Semi-opaque overlay: `backgroundGrey.opacity(0.8)`
- Centered spinner
- Field is disabled (no tap actions)

### Styling Rules

| Element | Color / Style |
|---------|---------------|
| Background circle | `brandPrimary.opacity(0.15)` |
| Initials text | `brandPrimary`, bold |
| Loading overlay | `backgroundGrey.opacity(0.8)` |
| Border | None (use clipShape(Circle())) |

### Implementation Notes

- **Remote image loading:** Uses Kingfisher; placeholder spinner during load
- **Failure handling:** Silent fallback to initials (no error UI)
- **Clipping:** Applied via `.clipShape(Circle())`
- **Initials format:** Capitalized, typically 2 characters (e.g., "JD" for John Doe)

### Example

```swift
DSAvatar(
    avatarURL: user.profileImageURL,
    initials: user.initials,  // "JD"
    size: .medium
)

// With local preview (e.g., from image picker)
DSAvatar(
    previewImage: selectedUIImage,
    initials: "JD",
    size: .large,
    isLoading: isUploadingImage
)
```

---

## 4. DSCard

**Purpose:** Elevated surface container for grouped content with optional glass morphism effect.

### When to Use

- Grouping related content (e.g., transaction details, user info)
- Creating visual hierarchy and separation
- Any content that needs subtle elevation
- Dashboard widgets

### When NOT to Use

- Do NOT use as a tap target — wrap in Button/NavigationLink
- Do NOT use for layouts exceeding one "card's worth" of vertical space
- Do NOT nest cards inside cards without explicit spacing

### Interface

```swift
struct DSCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content)
}
```

### Styling Rules

| Property | Value |
|----------|-------|
| Background | `glassEffect(cornerRadius: 32)` |
| Padding | 24pt all sides |
| Border | None |
| Shadow | Inherent to glass effect |

### Glass Effect

The card applies a SwiftUI glass effect (`.glassEffect()`) which provides:
- Frosted glass appearance
- Light blur
- Semi-transparent background (respects appearance)
- Smooth shadow

### Implementation Notes

- **No constraints:** Card expands to fill available width; height determined by content
- **Padding:** 24pt inside card (equivalent to `DSSpacing.space24`)
- **Corner radius:** 32pt (`DSRadius.full`)

### Example

```swift
DSCard {
    VStack(alignment: .leading, spacing: 12) {
        Text("Transaction")
            .dsTitle3()

        Text("$125.50")
            .dsHeadline()
            .foregroundColor(.success)

        Text("Completed 2 min ago")
            .dsCaption()
            .foregroundColor(.textTertiary)
    }
}
```

---

## 5. DSSwitch

**Purpose:** Toggle boolean state for settings, preferences, and feature flags.

### When to Use

- Enable/disable notifications, features, settings
- Paired with `DSListRow` for settings lists
- Any binary state toggle requiring haptic feedback

### When NOT to Use

- Do NOT use for required form validation (use checkbox instead)
- Do NOT use in place of radio buttons (mutually exclusive options)
- Do NOT nest switches or make switches toggles for other switches

### Interface

```swift
struct DSSwitch: View {
    @Binding var isOn: Bool
    let isEnabled: Bool = true
}
```

### Sizing & Colors

| State | Track Color | Border Color | Thumb | Haptic |
|-------|-------------|--------------|-------|--------|
| On (enabled) | `brandPrimary` | `brandPrimary.opacity(0.35)` | white circle (12pt) | `.selection` |
| Off (enabled) | `coolGrey.opacity(0.25)` | `coolGrey.opacity(0.18)` | white circle (12pt) | `.selection` |
| On (disabled) | `brandPrimary.opacity(0.45)` | `brandPrimary.opacity(0.2)` | white circle, 0.55 opacity | None |
| Off (disabled) | `coolGrey.opacity(0.15)` | `coolGrey.opacity(0.1)` | white circle, 0.55 opacity | None |

### Dimensions

- **Track:** 25pt width × 16pt height
- **Thumb:** 12pt diameter
- **Corner radius:** 16pt (fully rounded)
- **Padding:** 2pt around thumb

### Animation

Thumb translation uses `.spring(response: 0.28, dampingFraction: 0.72)`.

### Haptic Behavior

- Plays `.selection` haptic on toggle (only if `isEnabled == true`)
- No haptic on disabled toggle attempt (button disabled state prevents interaction)

### Touch Target

- Visual size: 25×16 pt
- Actual touch target: 44×44 pt via `.contentShape(Circle())`

### Implementation Notes

- **State binding:** Caller owns the binding and state
- **Accessibility:** Automatically labeled via `accessibilityLabel` parameter (caller responsibility)
- **No text:** Label is NOT part of the switch — use `DSListRow` or wrap in HStack with Text

### Example

```swift
@State private var notificationsEnabled = true

DSListRow(
    title: "Notifications",
    subtitle: "Receive alerts and updates"
) {
    DSSwitch(
        isOn: $notificationsEnabled
    )
}
```

---

## 6. DSListRow

**Purpose:** Consistent list item layout with icon, title, subtitle, and trailing content slot.

### When to Use

- Settings, preferences, menu items
- User lists, participant lists
- Action rows requiring icon + label + trailing control
- Navigation rows

### When NOT to Use

- Do NOT use for cards with complex layouts — use `DSCard` instead
- Do NOT nest list rows
- Do NOT use for horizontal scrolling lists

### Interface

```swift
struct DSListRow<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: BrandIcon?
    let trailingContent: Content?
}
```

### Styling Rules

| Element | Color / Style |
|---------|---------------|
| Title | `textPrimary`, `dsHeadline` |
| Subtitle | `coolGrey`, `dsBody` |
| Icon background | `brandPrimary.opacity(0.15)` circle |
| Icon foreground | `brandPrimary` |
| Container | `glassEffect(cornerRadius: 20)` |
| Padding | 16pt vertical, 20pt horizontal |

### Layout

```
┌─────────────────────────────────────┐
│  [icon] Title              [trailing] │
│          Subtitle                    │
└─────────────────────────────────────┘
```

- **Icon:** 32pt circle background, icon scaled to `.large`
- **Gap between icon & text:** 16pt
- **Title-subtitle gap:** 6pt
- **Trailing slot:** Right-aligned, respects natural width (e.g., switch, chevron, badge)

### Icon Sizing

- Icon inside background: `.large` scale
- Background circle: 32pt diameter

### Implementation Notes

- **Trailing overload:** Constructor allows generic `Content` or empty (`EmptyView`)
- **No tap handler:** Row itself is not tappable — wrap in NavigationLink or Button
- **Subtitle optional:** Show only meaningful supporting text

### Example

```swift
// With switch
DSListRow(
    title: "Dark Mode",
    subtitle: "Enabled for nighttime",
    icon: .moon
) {
    DSSwitch(isOn: $darkModeEnabled)
}

// With chevron (navigation)
NavigationLink {
    ProfileView()
} label: {
    DSListRow(
        title: "Profile",
        subtitle: "Manage account",
        icon: .user
    )
}

// No trailing, no icon
DSListRow(
    title: "Logout",
    subtitle: "Sign out of your account"
)
```

---

## 7. DSProgressView

**Purpose:** Multi-step progress indicator with visual completion status, labels, and descriptions.

### When to Use

- Multi-step wizards (signup, onboarding, forms)
- Process tracking (verification, upload, checkout)
- Visual confirmation of progress through flows

### When NOT to Use

- Do NOT use for simple progress bars (use SwiftUI's ProgressView)
- Do NOT use for indeterminate loading (use ProgressView + .indeterminate)
- Do NOT use for sub-step tracking within a single step

### Interface

```swift
struct DSProgressView: View {
    struct Progress: Identifiable, Hashable {
        struct Label: Hashable {
            let icon: BrandIcon
            let text: String
        }

        let id: UUID
        let title: String
        let body: String
        let label: Label
    }

    let progress: [Progress]
    let currentIndex: Int
}
```

### Styling Rules

| Element | Color | Font | State |
|---------|-------|------|-------|
| Step indicator circle | `brandPrimary` | `dsHeadline` semibold | Completed/current |
| Step indicator circle | `coolGrey` | `dsHeadline` semibold | Pending |
| Step number | Inherited from circle | — | — |
| Title | `textPrimary` | `dsHeadline` | — |
| Body text | `coolGrey` | `dsFootnote` | — |
| Label (badge) | `success` bg, `success` text | `dsCaption` | — |
| Connector line | `brandPrimary.opacity(0.45)` | — | Completed |
| Connector line | `coolGrey.opacity(0.25)` | — | Pending |
| Step circle border | `brandPrimary` | — | Completed/current |
| Step circle border | `coolGrey.opacity(0.35)` | — | Pending |

### Behavior

- **Completed steps (index < currentIndex):** Border and number in `brandPrimary`
- **Current step (index == currentIndex):** Circle background fill with brand color, enhanced shadow
- **Pending steps (index > currentIndex):** Border and number in `coolGrey`
- **Connector lines:** Show between steps; color depends on step completion state
- **Label:** Small badge always shown; typically indicates status (e.g., "Completed", "In Progress")

### Layout

```
┌─────────────────────────────────┐
│ ① Title                  Completed│
│ Description text here            │
│    ▼                             │
├─────────────────────────────────┤
│ ② Title                 In Review │
│ Description text here            │
│    ▼                             │
├─────────────────────────────────┤
│ ③ Title                   Pending │
│ Description text here            │
└─────────────────────────────────┘
```

### Implementation Notes

- **Index clamping:** `currentIndex` is automatically clamped to valid range (0 to count-1)
- **Step enumeration:** Uses `.enumerated()` with explicit `.id` for performance
- **Connector animation:** Connector color updates when `currentIndex` changes
- **No state transitions:** Steps do not animate between states — data changes trigger layout updates

### Example

```swift
@State private var currentStep = 0

let steps: [DSProgressView.Progress] = [
    .init(
        title: "Enter Number",
        body: "Provide your mobile number",
        label: .init(icon: .checkmark, text: "Verified")
    ),
    .init(
        title: "Verify OTP",
        body: "Enter the code we sent",
        label: .init(icon: .hourglass, text: "Pending")
    ),
    .init(
        title: "Complete Profile",
        body: "Add your details",
        label: .init(icon: .info, text: "Next")
    )
]

DSProgressView(progress: steps, currentIndex: currentStep)
```

---

## 8. DSNavigationBar

**Purpose:** Header bar with optional leading/trailing action buttons, title, and subtitle support.

### When to Use

- Top of every screen (use one per NavigationStack or view)
- Modal/sheet header
- Two display modes: inline (standard) and large (prominent titles)

### When NOT to Use

- Do NOT use multiple bars per screen
- Do NOT use for inline content navigation (use NavigationStack)
- Do NOT put form inputs in the bar

### Interface

```swift
struct DSNavigationBar<LeadingContent: View, TrailingContent: View>: View {
    let title: String
    let subtitle: String?
    let displayMode: DisplayMode
    let leadingContent: LeadingContent
    let trailingContent: TrailingContent

    enum DisplayMode {
        case inline      // Compact, 44pt min height
        case large       // Prominent, larger title
    }
}
```

### Display Modes

#### Inline Mode
- Height: 44pt minimum
- Title: `dsHeadline`, single line
- Subtitle: `dsCaption`, single line, below title
- Buttons: 44×44 pt minimum touch target
- Layout: Leading button | (title/subtitle centered) | Trailing button

#### Large Mode
- Height: Auto-expanding
- Title: `dsLargeTitle`, bold, can wrap
- Subtitle: `dsSubheadline`, below title
- Buttons: 44×44 pt minimum touch target
- Layout: Vertical stack with title first, buttons at top in HStack

### Styling Rules

| Element | Color | Font |
|---------|-------|------|
| Title (inline) | `textPrimary` | `dsHeadline` |
| Title (large) | `textPrimary` | `dsLargeTitle` |
| Subtitle | `textSecondary` / `textTertiary` | `dsCaption` / `dsSubheadline` |
| Background | `backgroundBase` with `.ultraThinMaterial` | — |
| Divider | `borderSubtle` | — |

### Button Slots

Both leading and trailing slots are ViewBuilder slots accepting any View:

```swift
DSNavigationBar(
    title: "Settings",
    displayMode: .inline,
    leading: {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.brandPrimary)
        }
    },
    trailing: {
        Button(action: { showMenu = true }) {
            Image(systemName: "ellipsis")
                .foregroundColor(.textSecondary)
        }
    }
)
```

### Implementation Notes

- **Background blur:** Uses `.ultraThinMaterial` for depth
- **Divider:** Thin line at bottom, using `borderSubtle` color
- **Padding:** 20pt horizontal, safe area respected
- **No auto-navigation:** Caller must implement back/dismiss actions

### Example

```swift
@Environment(\.dismiss) var dismiss

NavigationStack {
    VStack {
        DSNavigationBar(
            title: "Your Profile",
            subtitle: "Manage account settings",
            displayMode: .large,
            leading: {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            },
            trailing: {
                Button(action: { showEdit = true }) {
                    Image(systemName: "pencil")
                }
            }
        )

        ScrollView {
            // Content
        }
    }
}
```

---

## 9. DSAutoCarousel

**Purpose:** Horizontally scrolling carousel with auto-advance timer and gesture-pause behavior.

### When to Use

- Onboarding screens, testimonials, feature highlights
- Content galleries that auto-rotate
- Dashboard widgets rotating through data

### When NOT to Use

- Do NOT use for infinite/endless scrolling lists (use ScrollView or List)
- Do NOT use inside vertical scrolling contexts without explicit height
- Do NOT use if content changes per-tap or per-gesture (use manual TabView instead)

### Interface

```swift
struct DSAutoCarousel<Item: Identifiable, Content: View>: View
    where Item.ID: Hashable
{
    let items: [Item]
    let autoAdvanceInterval: TimeInterval       // default: 4 seconds
    let resumeDelay: TimeInterval               // default: 5 seconds
    let content: (Item) -> Content
}
```

### Behavior

1. **Auto-advance:** Rotates to next item every `autoAdvanceInterval` seconds
2. **User interaction pause:** Dragging or tapping pauses auto-advance
3. **Resume delay:** Auto-advance resumes after `resumeDelay` seconds of inactivity
4. **Wrapping:** Cycles back to first item after last
5. **Empty handling:** If `items.count == 0`, stays on index 0 (no crash)

### Styling Rules

| Element | Style |
|---------|-------|
| Page indicator | Hidden (`.never`) |
| Tab style | `.page` (SwiftUI standard) |
| Transition animation | `.easeInOut(duration: 0.25)` |

### Implementation Notes

- **Interaction detection:** Uses `DragGesture` with 0pt minimum distance (any gesture pauses)
- **Timer:** Published on `.main` thread, runs in `.common` runloop
- **Index validation:** Automatically clamps `currentIndex` if `items.count` changes
- **Content builder:** Closure signature `(Item) -> Content`

### Example

```swift
let features: [Feature] = [
    Feature(id: 1, title: "Transfer Money", image: "transfer"),
    Feature(id: 2, title: "Pay Bills", image: "bills"),
    Feature(id: 3, title: "Save & Invest", image: "invest")
]

DSAutoCarousel(
    items: features,
    autoAdvanceInterval: 5,
    resumeDelay: 8
) { feature in
    VStack {
        Image(feature.image)
            .resizable()
            .scaledToFill()

        Text(feature.title)
            .dsHeadline()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
.frame(height: 300)
```

---

## 10. DSAvatarCropper (Advanced)

**Purpose:** Image cropping tool for profile pictures and avatars.

### When to Use

- Post-image-picker, pre-upload avatar selection
- Profile picture setup flows
- Any UI requiring user-defined image framing

### When NOT to Use

- Do NOT use as primary image editor
- Do NOT use for batch operations
- Do NOT use without explicit user intent to crop

### Interface

Refer to component source for detailed API; primary use:

```swift
DSAvatarCropper(image: selectedImage, onSave: { croppedImage in
    // Handle cropped image
})
```

---

## 11. Tokens & Modifiers

### Typography Modifiers

All text uses extension methods on `View`. Never hard-code `Font()`:

```swift
Text("Headline")
    .dsHeadline()          // Bold, 17pt

Text("Body text")
    .dsBody()              // Regular, 17pt

Text("Small label")
    .dsCaption()           // Regular, 12pt
```

See `Typography+DesignSystem.swift` for complete reference.

### Color Usage

**Never use SwiftUI system colors directly.** Always use design system colors:

```swift
// ✅ Correct
Text("Error")
    .foregroundColor(.danger)

// ❌ Wrong
Text("Error")
    .foregroundColor(.red)
```

Available colors in `Color+DesignSystem.swift`.

### Spacing

Use constants from `DSSpacing` and `DSRadius`:

```swift
// ✅ Correct
VStack(spacing: DSSpacing.space16)
    .padding(DSSpacing.space20)
    .cornerRadius(DSRadius.medium)

// ❌ Wrong
VStack(spacing: 15)
    .padding(20)
    .cornerRadius(12)
```

---

## 12. ViewState Enum

Used across all components for consistent feedback:

```swift
public enum ViewState: Equatable {
    case idle              // Default
    case loading           // Async operation in progress
    case success           // Operation completed successfully
    case error(String)     // Operation failed with message
}
```

Callers are responsible for:
1. Initializing state as `.idle`
2. Setting to `.loading` before async operations
3. Setting to `.success` or `.error(_)` based on result
4. Clearing state (resetting to `.idle`) after sufficient time or user action

---

## 13. Implementation Checklist

When adding a new component:

- [ ] Define clear interface with minimal required parameters
- [ ] Use `ViewState` for async/feedback states
- [ ] Enforce 44×44 pt minimum touch targets
- [ ] Apply haptic feedback via `DSHaptics.shared` (only user-initiated)
- [ ] Use Spring animations (never `easeInOut` for non-critical transitions)
- [ ] Respect `accessibilityReduceMotion`
- [ ] Document `when to use / when NOT to use`
- [ ] Include example code
- [ ] Test with **AX5** (largest accessibility size)
- [ ] Verify contrast ratios (WCAG AAA on `backgroundBase`)
- [ ] Add to `DesignSystemPreviews.swift`
- [ ] Update this document

---

## 14. Color Contrast Verification

All components must meet **WCAG AAA (7:1)** on `backgroundBase` (#000011).

Verification matrix in `Atoms.md` § 4.

---

## 15. BrandIcon Usage

Icons are provided via the `BrandIcon` enum (defined in `BrandIcon.swift`):

```swift
enum BrandIcon {
    case chevronRight
    case error
    case checkmark
    case arrowRight
    case // ... others

    func view(scale: IconScale = .medium) -> some View
}

enum IconScale {
    case small
    case medium
    case large
}
```

Always use `icon.view()` or `icon.view(scale: .large)` — never hardcoded SF Symbols.

---

**Last updated:** 2026-04-02
**Maintained by:** Design Systems Team
