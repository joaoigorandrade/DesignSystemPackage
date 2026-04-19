# Groupool Design Token Reference

Extracted from `groupool/project/styles.css` and the JSX prototype components.
Use this file as the canonical token reference instead of reading the CSS directly.

---

## Color Tokens

### Semantic Base (Light Mode)

| Token | CSS Variable | Hex | Purpose |
|---|---|---|---|
| background | `--bg` | `#F5EFE3` | Page/screen background |
| surface | `--surface` | `#FFFDF7` | Card and sheet surfaces |
| ink | `--ink` | `#1A1814` | Primary text |
| ink2 / inkSecondary | `--ink-2` | `#5C574D` | Secondary text |
| ink3 / inkTertiary | `--ink-3` | `#8F8A7E` | Tertiary text, disabled |
| line | `--line` | `#E8DFCB` | Light borders |
| line2 / lineSecondary | `--line-2` | `#D8CEB6` | Medium borders |

### Dark Mode Overrides

| Token | Hex |
|---|---|
| background | `#151210` |
| surface | `#221E19` |
| ink | `#F4EEE0` |
| ink2 | `#A89E8A` |
| ink3 | `#6B6455` |
| line | `#2E2822` |
| line2 | `#3D362D` |
| poolSoft (blue accent only) | `#1A2A3E` |

### Pool / Accent Colors

Default accent is **blue**. Each accent has three tiers.

| Accent | Base | Deep | Soft |
|---|---|---|---|
| blue | `#3B82D4` | `#2A6AB8` | `#E1EEFA` |
| teal | `#1E8A8A` | `#156767` | `#DFEFEF` |
| coral | `#E06B4A` | `#B8502F` | `#FBE6DE` |
| violet | `#6B5CD3` | `#4E3FB0` | `#EAE5FB` |
| lime | `#6E9A2B` | `#547020` | `#E8F0D8` |

In Swift these map to: `pool` → base, `poolDeep` → deep, `poolSoft` → soft.

### Material / Wood

| Token | Hex |
|---|---|
| wood | `#D4B896` |
| woodDark | `#B89770` |

### Status / Feedback

| Token | Hex | Use |
|---|---|---|
| good | `#2F9E5E` | Success, positive |
| warn | `#E09429` | Warning, caution |
| bad | `#CC4A3C` | Error, negative |

---

## Border Radius Tokens

Default softness is **medium**.

| Token | Sharp | Medium | Bubbly |
|---|---|---|---|
| small | 4 | 10 | 16 |
| medium | 8 | 18 | 26 |
| large | 14 | 28 | 40 |
| extraLarge | 18 | 36 | 56 |

`GPRadii` constants represent the **medium** softness defaults.
`GroupoolRadius` functions accept a `GroupoolTheme` and return the softness-aware value.

---

## Typography

### Font Families

| Token | CSS Variable | Primary Font | Fallback |
|---|---|---|---|
| gpDisplay | `--font-display` | Fraunces | Georgia, serif |
| gpUI | `--font-ui` | Inter | -apple-system, sans-serif |
| gpMono | `--font-mono` | JetBrains Mono | SF Mono, monospace |

### Font Presets (Theme Variants)

| Preset | Display Family | UI Family |
|---|---|---|
| serifSans | Fraunces | Inter |
| sansSans | Inter | Inter |
| monoSans | JetBrains Mono | Inter |
| displaySans | Instrument Serif | Inter |

### Typography Scale (from `GroupoolTypography.Role`)

| Role | Size | Weight | Use |
|---|---|---|---|
| displayXL | 56 | medium | Hero headlines |
| displayL | 44 | medium | Section titles |
| displayM | 28 | medium | Card headers, large inputs |
| title | 20 | bold | Screen titles |
| bodyStrong | 17 | semibold | Emphasized body |
| body | 15 | regular | Body text |
| caption | 12 | medium | Captions, metadata |
| label | 11 | semibold | Form labels, chips (uppercase) |
| mono | 12 | medium | Amounts, codes |

### Tracking

| Role | Tracking |
|---|---|
| displayXL / L / M | -0.8 |
| title / body / bodyStrong | -0.2 |
| caption | 0.1 |
| label | 1.0 (uppercase look) |
| mono | 0 |

---

## Spacing Tokens

| Token | Value |
|---|---|
| xxxs | 4 |
| xxs | 6 |
| xs | 8 |
| sm | 10 |
| md | 12 |
| lg | 14 |
| xl | 16 |
| xxl | 18 |
| xxxl | 20 |
| section | 24 |

---

## Component Sizing Tokens (from CSS)

| Component | Property | Value |
|---|---|---|
| Button (regular) | height | 54 |
| Button (small) | height | 38 |
| Button | corner radius | `radius-l` (28 medium) |
| Card | border | 1px `line` |
| Card | corner radius | `radius-l` (28 medium) |
| Pill | height | 24 |
| Pill | corner radius | 999 (full capsule) |
| Avatar | default size | 40 |
| Avatar | corner radius | 999 (circular) |
| OTP Box | width × height | 44 × 56 |
| OTP Box | border | 1.5px `line` (filled: `pool`) |
| Status Dot | size | 14 × 14 |
| FAB | size | 60 × 60 |
| Tab Bar | icon size | 20 |
| Tab Bar | bottom padding | 26 (safe area) |

---

## Status Dot Mapping

| Status | Symbol | Color |
|---|---|---|
| good | checkmark | good (#2F9E5E) |
| observer | eye | violet soft/deep |
| inactive | dash | ink3 |
| debt | exclamationmark | bad (#CC4A3C) |
| restricted | exclamationmark | warn (#E09429) |

---

## Avatar Palette (Deterministic)

8 gradient pairs indexed by `unicode(firstChar) % 8`:

| Index | Color A | Color B |
|---|---|---|
| 0 | `#3B82D4` | `#2A6AB8` |
| 1 | `#1E8A8A` | `#156767` |
| 2 | `#E06B4A` | `#B8502F` |
| 3 | `#6B5CD3` | `#4E3FB0` |
| 4 | `#6E9A2B` | `#547020` |
| 5 | `#B8502F` | `#8C3A20` |
| 6 | `#2A6AB8` | `#1A4A8A` |
| 7 | `#9B59B6` | `#7D3C98` |

---

## Icon Set (SF Symbol Mappings)

| GP Name | SF Symbol | Notes |
|---|---|---|
| home | house.fill | — |
| activity | chart.bar.fill | — |
| ledger | list.bullet.clipboard | — |
| profile | person.fill | — |
| plus | plus | — |
| chevronRight | chevron.right | — |
| chevronLeft | chevron.left | — |
| close | xmark | — |
| check | checkmark | — |
| arrowUp | arrow.up | — |
| arrowDown | arrow.down | — |
| arrowRight | arrow.right | — |
| dollar | dollarsign | — |
| swords | ⚔ custom Path | No SF symbol |
| receipt | doc.text | — |
| users | person.2.fill | — |
| shield | shield.fill | — |
| clock | clock | — |
| bell | bell.fill | — |
| send | paperplane.fill | — |
| camera | camera.fill | — |
| eye | eye.fill | — |
| settings | gearshape.fill | — |
| whatsapp | custom Path | No SF symbol |
| pix | custom Path | No SF symbol |
| flag | flag.fill | — |
| more | ellipsis | — |
| copy | doc.on.doc | — |
| search | magnifyingglass | — |

---

## Animations

| Name | Duration | Behavior |
|---|---|---|
| shimmer | 3s infinite | ±2px translate Y |
| ripple | 1.6s | scale + opacity fade |
| bob | 3s infinite | ±3px translate Y |
| screenIn | 0.25s ease-out | fade + translate |

---

## Prototype Source Files

| File | Contents |
|---|---|
| `groupool/project/styles.css` | All CSS custom properties, component tokens, animation keyframes |
| `groupool/project/components/common.jsx` | Avatar, Icon, WaterFill, StatusDot, PoolMascot, GroupoolMark |
| `groupool/project/components/home.jsx` | TabBar, FAB, ActivityRow, StatusBanner, HomeScreen |
| `groupool/project/components/onboarding.jsx` | TopBar, OTP boxes, PhoneScreen, InviteLanding, QRPlaceholder |
| `groupool/project/components/challenge.jsx` | MemberChip, OutcomeRow, VoteOption, ProofThumb, StepperView |

---

## Migration Notes

This package exposes two parallel surfaces:

- **`Groupool*`** — original implementation, stable, used by existing app code
- **`GP*`** — new canonical surface, thin adapters over `Groupool*` internals

New code should use `GP*`. Existing `Groupool*` usages remain valid.
`Groupool*` types will be deprecated once all callers have migrated.
