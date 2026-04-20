# DesignSystem

SwiftUI design system package for Groupool. Prototype source of truth: `groupool/project/styles.css` and the JSX screen components at `groupool/project/components/`.

Token reference: [`Sources/DesignSystem/Theme/DesignTokenReference.md`](Sources/DesignSystem/Theme/DesignTokenReference.md)

---

## API Surfaces

The package exposes two parallel surfaces:

| Surface | Status | When to use |
|---|---|---|
| `GP*` | **Current** — new canonical API | All new code |
| `Groupool*` | Legacy — stable, no removals yet | Existing app code |

New code should use `GP*`. `Groupool*` types remain unchanged and will be deprecated once all callers have migrated.

---

## Design Principles

- Warm paper backgrounds (`#F5EFE3`) and creamy surfaces (`#FFFDF7`)
- Deep ink typography with softer secondary and tertiary text
- A blue pool accent by default; teal, coral, violet, and lime available
- Rounded wooden and water metaphors across cards, avatars, progress, and branding
- Display-forward typography with a serif headline voice and a clean sans UI layer

---

## Package Layout

```
Sources/DesignSystem/
  Theme/
    GroupoolTheme.swift          — theme dimensions and environment key
    GroupoolTokens.swift         — spacing, radius, typography, color extensions
    GroupoolTextStyles.swift     — .groupoolTextStyle() modifier
    GPColors.swift               — GP* semantic color accessors
    GPTypography.swift           — .gpDisplay() / .gpUI() / .gpMono() modifiers
    GPRadii.swift                — fixed medium-softness radius constants
    GPTokens.swift               — GP namespace typealias hub
    GPTypes.swift                — GPMemberStatus, GPTransactionKind, GPOutcomeColor
    DesignTokenReference.md      — canonical token documentation
  Components/
    Groupool*.swift              — legacy implementations (stable)
    GP*.swift                    — new GP* wrappers and additions
Resources/
  Colors.xcassets                — 29 named color assets
```

---

## Theme

```swift
// Inject a custom theme into a subtree
SomeView()
    .groupoolTheme(GroupoolTheme(
        accent: .coral,
        softness: .bubbly,
        fonts: .displaySans,
        mode: .dark
    ))

// Read the theme in a view
@Environment(\.groupoolTheme) private var theme
```

### Theme dimensions

| Dimension | Options |
|---|---|
| `Accent` | `blue` (default), `teal`, `coral`, `violet`, `lime` |
| `Softness` | `sharp`, `medium` (default), `bubbly` |
| `FontPreset` | `serifSans` (default), `sansSans`, `monoSans`, `displaySans` |
| `Mode` | `light` (default), `dark` |

---

## Tokens

### Colors (`GPColors`)

```swift
// Semantic colors from the current theme
let bg = GPColors.background(theme)
let accent = GPColors.pool(theme)
let inkSecondary = GPColors.ink2(theme)

// Fixed accent variants (no theme needed)
let highlight = GPColors.tealSoft
```

### Radii (`GPRadii`)

Fixed medium-softness defaults. For softness-aware values use `GroupoolRadius.large(for: theme)`.

```swift
RoundedRectangle(cornerRadius: GPRadii.large)
```

| Constant | Value |
|---|---|
| `GPRadii.small` | 10 |
| `GPRadii.medium` | 18 |
| `GPRadii.large` | 28 |
| `GPRadii.extraLarge` | 36 |

### Typography

```swift
Text("Groupool")
    .gpDisplay(size: 44)

Text("Bem-vindo")
    .gpUI(size: 17)

Text("R$ 50,00")
    .gpMono(size: 14, color: theme.good)

// Legacy (still works)
Text("Groupool")
    .groupoolTextStyle(.displayXL)
```

### Spacing (`GroupoolSpacing`)

`xxxs` 4 · `xxs` 6 · `xs` 8 · `sm` 10 · `md` 12 · `lg` 14 · `xl` 16 · `xxl` 18 · `xxxl` 20 · `section` 24

---

## Domain Types (`GPTypes`)

Lightweight display-only enums for components that need semantic state:

```swift
GPMemberStatus   // .good .observer .inactive .debt .restricted
GPTransactionKind // .neutral .frozen .credit
GPOutcomeColor   // .pool .good .warn .bad .neutral
```

---

## Components

### Identity

```swift
GPAvatarView(name: "Ana Silva", size: 40, status: .good)
GPStatusDotView(.debt)
GroupoolMarkView(size: 28)
PoolMascotView(size: 120, expression: .happy, showLadder: true)
```

### Buttons

```swift
Button("Continuar") {}
    .buttonStyle(.gp(.pool, fullWidth: true))

Button("Cancelar") {}
    .buttonStyle(.gp(.ghost, size: .small))
```

Variants: `primary`, `pool`, `ghost`, `subtle`. Sizes: `regular`, `small`.

### Surfaces

```swift
GPCard {
    Text("Content")
}

GPSectionHeader("Membros", trailing: "Ver todos")

GPCard(padding: 0) {
    GPListRow { /* leading */ } content: { /* main */ } trailing: { /* trailing */ }
}

ZStack {
    Color.groupoolBackground.ignoresSafeArea()

    ScrollView {
        GPCard { Text("Scrollable content") }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
    }
}
.safeAreaInset(edge: .bottom, spacing: 0) {
    GPBottomBar {
        Button("Continue") {}
            .buttonStyle(.gp(.primary, fullWidth: true))
    }
}
```

### Indicators

```swift
GPPillView("Pago", variant: .good)
GPStatusDotView(.observer)
GPOTPBoxView("3")
GPWaterFillView(percent: 65, label: "65%", height: 52)
GPPickerRowView(options: ["6h", "12h", "24h"], selection: $window, title: { $0 })
```

### Navigation

```swift
GPTopBarView(onBack: { dismiss() }, step: 2, total: 5)

GPTabBarView(activeTab: $tab) { selected in
    navigate(to: selected)
}

GPFloatingButton {
    openQuickActions()
}
```

### Forms

```swift
GPFormLabel("Nome do desafio")
GPTextField(title: "Valor", text: $amount, prompt: "0,00", isBig: true, prefix: { Text("R$") })
GPTextField(title: "Descrição", text: $bio, isMultiline: true)
```

### Rows

```swift
GPActivityRowView(icon: .send, title: "Transferência", subtitle: "Para Ana", amount: "- R$ 50", kind: .neutral)
GPMemberChipView(name: "Bruno Costa", subtitle: "@bruno", selected: true) { toggle() }
GPOutcomeRowView(letter: "A", title: "João vence", subtitle: "Chegou primeiro", color: .good)
GPVoteOptionView(letter: "A", title: "João vence", votes: 3, totalVotes: 5, isPicked: true) { pick() }
GPProofThumbView(label: "foto.jpg", subtitle: "2.4 MB")
GPRowView(title: "Prazo", icon: .clock, trailing: "24h")
GPStatTileView(label: "Saldo", value: "R$ 420", icon: .dollar)
```

### Feedback and Status

```swift
GPStatusBannerView(.debt) {
    Text("Você tem R$ 50,00 pendentes.")
}
GPTrackBadgeView("Ativo", variant: .good)
GPStepperView(currentStep: 3, totalSteps: 5)
```

### Screen Layout

```swift
ZStack {
    Color.groupoolBackground.ignoresSafeArea()

    ScrollView {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                GPTopBarView(onBack: {}, step: 2, total: 5)
                Text("Create challenge")
                    .gpDisplay(size: 28)
            }

            GPCard { Text("Step content") }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 24)
    }
}
.safeAreaInset(edge: .bottom, spacing: 0) {
    GPBottomBar {
        Button("Continue") {}
            .buttonStyle(.gp(.pool, fullWidth: true))
    }
}
```

### Special

```swift
GPQRPlaceholderView(size: 200)
```

---

## Recommended Composition by Screen

| Screen | Components |
|---|---|
| Splash / Onboarding | `PoolMascotView`, `GPTopBarView`, `GPButton (.pool)`, `GPTextField`, `GPOTPBoxView` |
| Home dashboard | `GroupoolMarkView`, `GPStatusBannerView`, `GPCard`, `GPWaterFillView`, `GPAvatarView`, `GPActivityRowView`, `GPTabBarView`, `GPFloatingButton` |
| Invite / PIX payment | `GPCard`, `GPPillView`, `GPProofThumbView`, `GPQRPlaceholderView`, `GPButton` |
| Challenge create | `GPTopBarView`, `GPStepperView`, `GPPickerRowView`, `GPMemberChipView`, `GPOutcomeRowView`, `GPTextField` |
| Challenge vote | `GPTopBarView`, `GPVoteOptionView`, `GPProofThumbView`, `GPButton (.pool)` |

---

## Adding Fonts

To match the prototype exactly, add these fonts to the host app target:

- `Fraunces` (display serif, serifSans preset)
- `Instrument Serif` (alternate display, displaySans preset)
- `Inter` (UI sans, all presets)
- `JetBrains Mono` (monospace, mono roles)

The package falls back to system fonts automatically if any are missing.

---

## Migration Guide (`Groupool*` → `GP*`)

Most types are 1-to-1 aliases or thin wrappers:

| Old | New |
|---|---|
| `GroupoolButtonStyle` · `.groupool(...)` | `.gp(...)` |
| `GroupoolCard` | `GPCard` (typealias) |
| `GroupoolListRow` | `GPListRowView` (typealias) |
| `GroupoolFormLabel` | `GPFormLabel` (typealias) |
| `GroupoolInputField` | `GPTextField` |
| `GroupoolAvatar` | `GPAvatarView` |
| `GroupoolStatusDot` | `GPStatusDotView` |
| `GroupoolStatusDotKind` | `GPMemberStatus` |
| `GroupoolActivityRow` | `GPActivityRowView` |
| `GroupoolMemberChip` | `GPMemberChipView` |
| `GroupoolOutcomeRow` | `GPOutcomeRowView` |
| `GroupoolProofThumbnail` | `GPProofThumbView` |
| `GroupoolStatusBanner` | `GPStatusBannerView` |
| `GroupoolTopBar` | `GPTopBarView` |
| `GroupoolTabBar` | `GPTabBarView` |
| `GroupoolMascot` | `PoolMascotView` (typealias) |
| `GroupoolMark` | `GroupoolMarkView` (typealias) |
| `GroupoolWaterFill` | `GPWaterFillView` |
| `GroupoolSegmentedControl` | `GPPickerRowView` (typealias) |
| `GroupoolOTPCell` | `GPOTPBoxView` (typealias) |
| `GroupoolPill` | `GPPillView` |
| `GroupoolIcon` | `GPIcon` (with typed `GPIconName` enum) |

---

## Tests

`Tests/DesignSystemTests/DesignSystemTests.swift` covers:

- Default theme matches prototype root tokens
- All three radius softness tables (sharp / medium / bubbly)
- `GPRadii` fixed constants match medium defaults
- Accent enum covers all five variants
- Changing accent changes the pool color
- All `GP*` domain type case counts
- Typography tracking direction by role
- Avatar initials extraction and deterministic palette hashing
