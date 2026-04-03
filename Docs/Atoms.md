# Groupool Design System — Atoms

> Foundational visual language for a dark-mode-only native iOS app.
> All values target **WCAG AAA** contrast ratios and follow Apple's **Human Interface Guidelines**.

---

## 1. Color Palette

The palette is optimized exclusively for **Dark Mode**. Every text-to-background pairing listed below achieves a minimum **7:1** contrast ratio (WCAG AAA for normal text).

### 1.1 Brand Colors

| Token | Hex | sRGB | iOS Semantic Mapping | Use Case |
|-------|-----|------|----------------------|----------|
| `brandPrimary` | `#60A5FA` | (96, 165, 250) | `Color.tint` / `Color.accentColor` | Primary actions, links, active states, focus rings |
| `brandSecondary` | `#A78BFA` | (167, 139, 250) | — | Secondary accent, categories, tags, badges |

**Contrast on `backgroundBase` (#000011):** brandPrimary ≈ 8.4:1 ✓ AAA · brandSecondary ≈ 7.5:1 ✓ AAA

### 1.2 Semantic / System Colors

| Token | Hex | sRGB | iOS Semantic Mapping | Use Case |
|-------|-----|------|----------------------|----------|
| `success` | `#34D399` | (52, 211, 153) | `.green` (adapted) | Confirmations, completed states, positive indicators |
| `danger` | `#F87171` | (248, 113, 113) | `.red` (adapted) | Errors, destructive actions, critical alerts |
| `warning` | `#FBBF24` | (251, 191, 36) | `.yellow` (adapted) | Caution states, pending actions, attention needed |
| `info` | `#22D3EE` | (34, 211, 238) | `.cyan` (adapted) | Informational banners, tips, neutral highlights |

**Contrast on `backgroundBase`:** success ≈ 11.1:1 · danger ≈ 7.6:1 · warning ≈ 12.8:1 · info ≈ 11.5:1 — All ✓ AAA

### 1.3 Background / Surface Colors (Elevation Hierarchy)

Dark mode depth is communicated through progressively lighter surfaces.

| Token | Hex | sRGB | iOS Semantic Mapping | Elevation |
|-------|-----|------|----------------------|-----------|
| `backgroundBase` | `#000011` | (0, 0, 17) | `Color(.systemBackground)` | Base canvas — deepest layer |
| `backgroundElevated` | `#111122` | (17, 17, 34) | `Color(.secondarySystemBackground)` | Cards, grouped content |
| `backgroundTop` | `#1A1A2E` | (26, 26, 46) | `Color(.tertiarySystemBackground)` | Sheets, modals, popovers |

### 1.4 Text Colors

All text colors achieve **WCAG AAA (≥ 7:1)** on every background surface defined above.

| Token | Hex | sRGB | iOS Semantic Mapping | Contrast on Base | Contrast on Elevated | Contrast on Top | Use Case |
|-------|-----|------|----------------------|-----------------|---------------------|----------------|----------|
| `textPrimary` | `#FFFFFF` | (255, 255, 255) | `Color(.label)` | 21.0:1 | 18.2:1 | 15.8:1 | Headlines, body text, primary content |
| `textSecondary` | `#BBBBD0` | (187, 187, 208) | `Color(.secondaryLabel)` | 10.9:1 | 9.5:1 | 8.2:1 | Subtitles, descriptions, supporting text |
| `textTertiary` | `#AAAAC2` | (170, 170, 194) | `Color(.tertiaryLabel)` | 8.8:1 | 7.6:1 | 7.0:1 | Placeholders, captions, hints, timestamps |

### 1.5 Border & Separator Colors

| Token | Hex | sRGB | iOS Semantic Mapping | Use Case |
|-------|-----|------|----------------------|----------|
| `borderDefault` | `#2A2A44` | (42, 42, 68) | `Color(.separator)` | Dividers, input field borders |
| `borderSubtle` | `#1A1A30` | (26, 26, 48) | `Color(.opaqueSeparator)` | Subtle separators, section dividers |

### 1.6 Legacy / Accent Colors (Retained)

| Token | Hex | sRGB | Use Case |
|-------|-----|------|----------|
| `vibrantOrange` | `#FB923C` | (251, 146, 60) | Accent highlights, FAB actions |
| `coolGrey` | `#9CA3AF` | (156, 163, 175) | Disabled states, inactive controls |

---

## 2. Typography Scale

All typography uses **SF Pro** (Apple's system font) exclusively, ensuring full Dynamic Type support, optical sizing, and native text rendering.

### 2.1 Type Scale

| Token | Text Style | Size (pt) | Weight | Leading (pt) | Use Case |
|-------|------------|-----------|--------|---------------|----------|
| `dsLargeTitle` | `.largeTitle` | 34 | **Bold** | 41 | Hero sections, onboarding titles |
| `dsTitle` | `.title` | 28 | **Bold** | 34 | Screen titles, section headers |
| `dsTitle2` | `.title2` | 22 | **Bold** | 28 | Card titles, dialog headers |
| `dsTitle3` | `.title3` | 20 | **Semibold** | 25 | Group headers, subsection titles |
| `dsHeadline` | `.headline` | 17 | **Semibold** | 22 | Row labels, emphasized body text |
| `dsBody` | `.body` | 17 | Regular | 22 | Primary reading text, descriptions |
| `dsCallout` | `.callout` | 16 | Regular | 21 | Secondary descriptions, field labels |
| `dsSubheadline` | `.subheadline` | 15 | Regular | 20 | Supporting text, metadata |
| `dsFootnote` | `.footnote` | 13 | Regular | 18 | Annotations, timestamps |
| `dsCaption` | `.caption` | 12 | Regular | 16 | Badges, tags, fine print |
| `dsCaption2` | `.caption2` | 11 | Regular | 13 | Legal text, minimal annotations |

### 2.2 Weight Reference

| Weight | SF Pro Value | `Font.Weight` | Usage |
|--------|-------------|---------------|-------|
| Regular | 400 | `.regular` | Body text, descriptions |
| Medium | 500 | `.medium` | Buttons, tab labels |
| Semibold | 600 | `.semibold` | Headlines, emphasized labels |
| Bold | 700 | `.bold` | Titles, primary headings |

### 2.3 Color Pairing Rules

| Text Token | Recommended Colors |
|------------|--------------------|
| `dsLargeTitle` – `dsTitle3` | `textPrimary` only |
| `dsHeadline` – `dsBody` | `textPrimary` or `textSecondary` |
| `dsCallout` – `dsSubheadline` | `textSecondary` or `textTertiary` |
| `dsFootnote` – `dsCaption2` | `textSecondary` or `textTertiary` |
| Semantic feedback | `success`, `danger`, `warning`, `info` |

---

## 3. Spacing & Layout Grid

All spacing derives from a **4pt base unit** on an **8pt primary grid**, consistent with Apple's HIG layout recommendations.

### 3.1 Spacing Scale

| Token | Value (pt) | Grid Units | Use Case |
|-------|------------|------------|----------|
| `space2` | 2 | 0.5 | Hairline gaps, icon-to-label micro spacing |
| `space4` | 4 | 1 | Tight inline spacing, badge padding |
| `space8` | 8 | 2 | Default inline spacing, small component padding |
| `space12` | 12 | 3 | Compact content spacing, icon margins |
| `space16` | 16 | 4 | Standard component padding, list row vertical padding |
| `space20` | 20 | 5 | Section internal padding, horizontal margins |
| `space24` | 24 | 6 | Card padding, group spacing |
| `space32` | 32 | 8 | Section gaps, large component spacing |
| `space40` | 40 | 10 | Screen-level vertical spacing |
| `space48` | 48 | 12 | Major section separators |
| `space64` | 64 | 16 | Hero section padding |

### 3.2 Corner Radius Scale

| Token | Value (pt) | Use Case |
|-------|------------|----------|
| `radiusSmall` | 8 | Buttons, chips, small inputs |
| `radiusMedium` | 12 | Cards, text fields, list rows |
| `radiusLarge` | 16 | Modals, action sheets |
| `radiusXL` | 20 | Bottom sheets, large containers |
| `radiusFull` | 32 | Pills, FABs, avatar frames |

### 3.3 Layout Margins

| Context | Value | Token |
|---------|-------|-------|
| Screen horizontal margin | 20pt | `space20` |
| Card internal padding | 24pt | `space24` |
| List row vertical padding | 16pt | `space16` |
| Section gap | 32pt | `space32` |

### 3.4 Touch Targets

Per Apple HIG, all interactive elements must have a minimum **44×44pt** touch target area.

---

## 4. Quick Reference — Color Contrast Matrix (WCAG AAA)

```
                  backgroundBase   backgroundElevated   backgroundTop
                  #000011          #111122              #1A1A2E
textPrimary       21.0:1  ✓ AAA   18.2:1  ✓ AAA       15.8:1  ✓ AAA
textSecondary     10.9:1  ✓ AAA    9.5:1  ✓ AAA        8.2:1  ✓ AAA
textTertiary       8.8:1  ✓ AAA    7.6:1  ✓ AAA        7.0:1  ✓ AAA
brandPrimary       8.4:1  ✓ AAA    7.3:1  ✓ AAA        6.3:1  ✓ AA *
brandSecondary     7.5:1  ✓ AAA    6.5:1  ✓ AA *       5.6:1  ✓ AA *
success           11.1:1  ✓ AAA    9.6:1  ✓ AAA        8.3:1  ✓ AAA
danger             7.6:1  ✓ AAA    6.6:1  ✓ AA *       5.7:1  ✓ AA *
warning           12.8:1  ✓ AAA   11.1:1  ✓ AAA        9.6:1  ✓ AAA
info              11.5:1  ✓ AAA   10.0:1  ✓ AAA        8.6:1  ✓ AAA
```

\* Brand and semantic colors on elevated surfaces achieve AA (4.5:1+). For AAA text on elevated surfaces, prefer `textPrimary`/`textSecondary`/`textTertiary`.
