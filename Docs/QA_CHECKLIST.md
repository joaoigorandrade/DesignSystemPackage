# QA Checklist — Design System Implementation

## Overview

This checklist ensures developers correctly implement design system components while respecting established constraints. Use this during code review and manual testing.

---

## Pre-Implementation Review

### Component Selection
- [ ] Developer chose correct component for use case (not reimplemented existing component)
- [ ] Component interface matches documented signature in `COMPONENTS.md`
- [ ] Component is used from `@Groupool/Packages/DesignSystem` (not copied/pasted)
- [ ] All required parameters are provided (no hardcoded fallbacks at call site)

### Architecture Compliance
- [ ] No business logic in view body (all logic in ViewModel or modifier)
- [ ] State management uses correct binding type:
  - [ ] `@State` only for UI-internal state (animations, sheet presentations)
  - [ ] `@ObservedObject` / `@StateObject` for ViewModel instances
  - [ ] No prop drilling beyond 2 levels (use `@Environment` if deeper)
- [ ] View body ≤ 20 lines (extracted subviews if exceeded)

---

## DSButton Implementation

### Interface Compliance
- [ ] All parameters specified (no reliance on defaults)
- [ ] `title` is non-empty string
- [ ] `style` is one of: `.primary`, `.secondary`, `.tertiary`, `.destructive`
- [ ] `state` is properly initialized (default `.idle` at first render)
- [ ] `isDisabled` reflects actual form validity or async state
- [ ] `action` closure does not block main thread
- [ ] `tapHaptic` is explicitly set or `nil` (checked that default is intentional)
- [ ] `stateHapticsEnabled` is set per use case

### State Management
- [ ] Button state starts as `.idle`
- [ ] On tap, state transitions to `.loading` before async work begins
- [ ] On error, state transitions to `.error(message)` with user-facing message
- [ ] On success, state transitions to `.success` and persists until parent clears
- [ ] Error/success states are cleared after sufficient UI time (e.g., 3 sec delay or user navigation)
- [ ] ❌ Button state is NOT used to show validation errors for form fields (use `DSTextField` state instead)

### Styling
- [ ] Button width matches intended style:
  - [ ] `.primary` / `.secondary` / `.destructive` → full width
  - [ ] `.tertiary` → intrinsic width
- [ ] Background color matches style:
  - [ ] `.primary` → `brandPrimary`
  - [ ] `.secondary` → transparent with border
  - [ ] `.tertiary` → transparent, no border
  - [ ] `.destructive` → `danger`
- [ ] Text is white on dark backgrounds (primary, destructive) or brand-colored on transparent
- [ ] Disabled opacity is applied and visible
- [ ] Press scale animation is smooth (0.96 scale)
- [ ] Shadow reduces on press (no fixed shadow on active state)

### Haptics
- [ ] `tapPrimary` haptic plays on primary/destructive tap
- [ ] `tapSecondary` haptic plays on secondary/tertiary tap
- [ ] `success` haptic plays on state transition to `.success` (if enabled)
- [ ] `error` haptic plays on state transition to `.error` (if enabled)
- [ ] ❌ No haptics play during `.loading` state
- [ ] ❌ Haptics do not double-fire (checked that caller doesn't also call DSHaptics)

### Accessibility
- [ ] Min touch target is 44×44 pt (verified via preview or live test)
- [ ] Button has accessible label (automatic from title Text)
- [ ] Loading state updates accessibility label or posts `.updatesFrequently` trait
- [ ] Disabled state is announced (automatic)

---

## DSTextField Implementation

### Interface Compliance
- [ ] All parameters specified (no defaults assumed)
- [ ] `label` is provided if field is required; omitted if only placeholder needed
- [ ] `placeholder` is clear and instructive
- [ ] `text` binding points to correct ViewModel property
- [ ] `state` is properly initialized (default `.idle`)
- [ ] `helperText` provides guidance (not repeated instruction)
- [ ] `characterLimit` is set if applicable (e.g., bio fields, phone numbers)
- [ ] `isSecure` is true for passwords, false otherwise
- [ ] `keyboardType` matches expected input (`.emailAddress`, `.phonePad`, `.numberPad`, etc.)
- [ ] `textContentType` is set for password managers and autocomplete
- [ ] `autocapitalization` is set correctly (`.none` for emails, URLs; `.sentences` default for prose)
- [ ] `onSubmit` is wired to form submission or next field focus

### Validation Flow
- [ ] ❌ Field does NOT validate — validation logic is in ViewModel
- [ ] On text change, ViewModel validates and sets state
- [ ] State transitions:
  - [ ] `.idle` → user starts typing
  - [ ] `.idle` → `.error(message)` on validation failure (called by ViewModel)
  - [ ] `.error(_)` → `.idle` on corrected input
  - [ ] `.idle` → `.success` on successful submission (optional)
  - [ ] `.success` → cleared after 2–3 sec or on next edit
- [ ] Character limit is enforced (text clamped client-side, not validation only)

### Styling
- [ ] Label appears above field (if provided)
- [ ] Label color changes on focus (brand-colored) and error (danger-colored)
- [ ] Placeholder text is visible and distinct from input text
- [ ] Border is 1pt at rest, 2.5pt when focused
- [ ] Border color: `borderDefault` (idle), `brandPrimary` (focused), `danger` (error), `success` (success)
- [ ] Shadow expands on focus with brand color glow
- [ ] Glass effect is applied (rounded, semi-transparent background)
- [ ] Status icon appears correctly: spinner (loading), checkmark (success), error icon (error), clear button (focused, non-secure)
- [ ] Footer shows: error message (error), helper text (idle/success), character count (if limit set)

### Clear Button Behavior
- [ ] Clear button appears only when:
  - [ ] Field is focused
  - [ ] Text is non-empty
  - [ ] Field is not secure (password fields do not show clear button)
- [ ] Tap clears text with spring animation
- [ ] Clear button is accessible via accessibility actions

### Accessibility
- [ ] Min touch target is 44×44 pt (status icon area + input)
- [ ] Label + placeholder provide clear input purpose
- [ ] Character limit feedback is announced (e.g., "10 of 50 characters")
- [ ] Error messages are announced when state changes
- [ ] Helper text provides additional guidance (no redundancy with placeholder)

---

## DSAvatar Implementation

### Interface Compliance
- [ ] `avatarURL` is provided (or nil if using fallback)
- [ ] `previewImage` is provided only when showing local preview (e.g., post-picker)
- [ ] `initials` is provided (always required, always a fallback)
- [ ] `initials` format: capitalized, typically 2 characters (e.g., "JD")
- [ ] `size` is one of: `.small` (44pt), `.medium` (72pt), `.large` (112pt), `.custom(n)`
- [ ] `isLoading` indicates async state (e.g., during upload)

### Content Priority
- [ ] If `previewImage` is present, it is displayed (highest priority)
- [ ] If `avatarURL` is present and no preview, remote image loads
- [ ] If URL fails or missing, initials are shown (silent fallback, no error state)
- [ ] ❌ Multiple content sources are not mixed (prefer one source)

### Image Loading
- [ ] Placeholder spinner appears during URL load
- [ ] Failure is silent (fallback to initials without error UI)
- [ ] Kingfisher caching is leveraged (no manual caching)

### Styling
- [ ] Background circle is `brandPrimary.opacity(0.15)` (light blue on dark background)
- [ ] Initials text is `brandPrimary`, bold
- [ ] Initials size matches expected typography for avatar size
- [ ] Circle is clipped (no rough edges)
- [ ] Loading overlay (`backgroundGrey.opacity(0.8)`) covers image during load

### Touch Target
- [ ] Avatar is not tappable by itself; wrapped in Button if needed
- [ ] If tappable, tap target includes surrounding space (at least 44×44 pt total)

### Accessibility
- [ ] Avatar has accessibility label describing user (e.g., "John Doe's profile picture")
- [ ] Loading state is announced (optional, but recommended)

---

## DSCard Implementation

### Interface Compliance
- [ ] Content is passed via ViewBuilder closure
- [ ] Card is not used as a tap target (wrapped in NavigationLink/Button if needed)

### Styling
- [ ] Glass effect is applied (rounded, blur, frosted appearance)
- [ ] Padding is 24pt all sides (`DSSpacing.space24`)
- [ ] Corner radius is 32pt (`DSRadius.full`)
- [ ] No border or explicit shadow (glass effect provides elevation)

### Layout
- [ ] Card expands to available width
- [ ] Height is determined by content
- [ ] Content inside card respects padding (no content touching edges)
- [ ] ❌ Cards are not nested without explicit spacing

---

## DSSwitch Implementation

### Interface Compliance
- [ ] `isOn` binding points to correct ViewModel property
- [ ] `isEnabled` reflects interaction allowance (e.g., disabled while loading)
- [ ] Switch is wrapped in labeled context (e.g., `DSListRow` with title)

### State & Binding
- [ ] Binding updates correctly on toggle (toggled via `withAnimation`)
- [ ] Switch reflects ViewModel state on parent update
- [ ] No two-way binding loops detected

### Styling
- [ ] Track colors:
  - [ ] On (enabled): `brandPrimary`
  - [ ] Off (enabled): `coolGrey.opacity(0.25)`
  - [ ] On (disabled): `brandPrimary.opacity(0.45)`
  - [ ] Off (disabled): `coolGrey.opacity(0.15)`
- [ ] Thumb is white circle (12pt diameter)
- [ ] Border is visible and matches track state
- [ ] Opacity is 0.55 when disabled
- [ ] Animation is smooth spring motion (no snappy jumps)

### Haptics
- [ ] `.selection` haptic plays on toggle (enabled state only)
- [ ] ❌ No haptic on disabled state (button disabled prevents interaction)

### Accessibility
- [ ] Switch is labeled (caller provides via `accessibilityLabel`)
- [ ] Label describes what is controlled, not the state (e.g., "Notifications" not "On/Off")
- [ ] Accessibility value is "On" / "Off" (caller implements)
- [ ] Touch target is 44×44 pt (with `.contentShape`)

---

## DSListRow Implementation

### Interface Compliance
- [ ] `title` is non-empty, meaningful label
- [ ] `subtitle` is provided only if supporting text adds value (optional)
- [ ] `icon` is a BrandIcon (not SF Symbols, not system image)
- [ ] `trailingContent` is provided via ViewBuilder (or row is created without trailing slot)

### Icon Sizing
- [ ] Icon is displayed at `.large` scale
- [ ] Icon background is 32pt circle
- [ ] Icon color is `brandPrimary`
- [ ] Icon background is `brandPrimary.opacity(0.15)`

### Styling
- [ ] Title is `dsHeadline` weight, `textPrimary` color
- [ ] Subtitle is `dsBody`, `coolGrey` color
- [ ] Container is `glassEffect(cornerRadius: 20)`
- [ ] Padding is 16pt vertical, 20pt horizontal
- [ ] Spacing between icon and text is 16pt
- [ ] Spacing between title and subtitle is 6pt

### Trailing Content
- [ ] Trailing slot respects natural width of content (e.g., switch, badge)
- [ ] Trailing element is right-aligned, not stretched
- [ ] ❌ Complex layouts are not put in trailing slot (use `DSCard` instead)

### Accessibility
- [ ] Row is not tappable (wrapped in NavigationLink or Button if needed)
- [ ] Icon is not separately labeled (label comes from title/subtitle)
- [ ] Touch target (if used as NavigationLink) is 44×44 pt min

---

## DSProgressView Implementation

### Interface Compliance
- [ ] `progress` array contains valid Progress items
- [ ] Each Progress has:
  - [ ] Unique `id` (UUID generated, not manual)
  - [ ] Non-empty `title`
  - [ ] Non-empty `body` (description)
  - [ ] `label` with icon and text (e.g., "Completed", "Pending")
- [ ] `currentIndex` is within valid range (0 to count-1)
- [ ] ❌ `currentIndex` is NOT directly bound to scroll position; it's set when step changes

### Behavior
- [ ] Steps update visually when `currentIndex` changes
- [ ] Completed steps (index < currentIndex) show brand-colored number and border
- [ ] Current step (index == currentIndex) shows background fill and glow
- [ ] Pending steps (index > currentIndex) show grey number and border
- [ ] Connector lines between steps reflect completion state
- [ ] Empty array handled gracefully (no crash)
- [ ] Dynamic item count changes are handled (re-clamps index if necessary)

### Styling
- [ ] Step circle: 32pt diameter, contains step number (1-indexed)
- [ ] Step number: `dsHeadline` semibold, brand-colored (completed) or grey (pending)
- [ ] Title: `dsHeadline`, `textPrimary`
- [ ] Body: `dsFootnote`, `coolGrey`
- [ ] Label badge: `success` background, small rounded capsule with icon + text
- [ ] Connector line: 2pt width, extends downward between steps
- [ ] Spacing: 8pt between elements, left-aligned with 16pt margin

### Accessibility
- [ ] Step numbers are announced (automatic via Text)
- [ ] Current step is visually distinct (no need for explicit "current" announcement)
- [ ] Label badge text is read (automatic from Text)

---

## DSNavigationBar Implementation

### Interface Compliance
- [ ] `title` is non-empty, descriptive
- [ ] `subtitle` is provided only if additional context is needed
- [ ] `displayMode` is `.inline` (standard) or `.large` (prominent)
- [ ] `leading` and `trailing` are ViewBuilder slots containing buttons or empty views
- [ ] ❌ Complex content (forms, search bars) is NOT in bar

### Display Mode — Inline
- [ ] Min height is 44pt
- [ ] Title and subtitle are centered vertically
- [ ] Leading and trailing buttons are 44×44 pt min
- [ ] Buttons are left/right aligned (not centered)
- [ ] Subtitle (if present) appears below title, smaller font

### Display Mode — Large
- [ ] Title is `dsLargeTitle`, bold
- [ ] Subtitle is `dsSubheadline` (if present)
- [ ] Buttons are in top HStack (above text)
- [ ] Height expands based on content
- [ ] Text can wrap (title may exceed one line)

### Styling
- [ ] Background is `backgroundBase` with `.ultraThinMaterial` blur
- [ ] Bottom divider is `borderSubtle` color, thin line
- [ ] Title color is `textPrimary`
- [ ] Subtitle color is `textSecondary` (inline) or `textTertiary` (large)
- [ ] Padding respects safe area
- [ ] Horizontal padding is 20pt (`DSSpacing.space20`)

### Button Slots
- [ ] Leading content is typically back button (chevron left)
- [ ] Trailing content is typically menu, settings, or action button
- [ ] Buttons in slots trigger actions (no automatic navigation)
- [ ] Caller owns back/dismiss logic (bar does not navigate)

### Accessibility
- [ ] Buttons have clear labels (e.g., "Back", "Menu", "Settings")
- [ ] Focus order: leading → title → trailing, top to bottom
- [ ] Title is pronounced (automatic from Text)

---

## DSAutoCarousel Implementation

### Interface Compliance
- [ ] Items array conforms to `Identifiable` with `Hashable` `ID`
- [ ] `autoAdvanceInterval` is in seconds (e.g., 4 for 4 seconds)
- [ ] `resumeDelay` is in seconds (typically > `autoAdvanceInterval`)
- [ ] Content builder takes Item and returns View

### Behavior
- [ ] Carousel auto-advances to next item every `autoAdvanceInterval`
- [ ] User drag or tap pauses auto-advance
- [ ] Auto-advance resumes after `resumeDelay` of inactivity
- [ ] Carousel loops (last item → first item)
- [ ] Empty array does not crash (stays on index 0)
- [ ] Item count changes are handled (index re-clamped if necessary)

### Styling
- [ ] Page indicator is hidden (`.never`)
- [ ] Transition animation: `.easeInOut(duration: 0.25)` (or specified curve)
- [ ] Swipe behavior is natural (left-to-right gesture moves backward)

### Performance
- [ ] ❌ Content builder is not excessively complex (simple layout only)
- [ ] Enumeration uses explicit `.id` for correct diffing
- [ ] Timer is stopped when carousel is off-screen (if in scrollable context, might need manual pause)

### Accessibility
- [ ] Current item index is announced (optional, but helpful)
- [ ] Carousel respects `accessibilityReduceMotion` (no pause/resume animations with reduce-motion on)

---

## Cross-Component Tests

### Color Contrast
- [ ] Text on all backgrounds meets WCAG AAA (7:1 minimum)
- [ ] Text on dark backgrounds: `textPrimary` only
- [ ] Labels on colored backgrounds: white or `textPrimary`
- [ ] Run contrast checker on all color+background pairings

### Typography
- [ ] All Text uses `dsHeadline()`, `dsBody()`, `dsCaption()`, etc. (no hardcoded fonts)
- [ ] No `Font.system(size: X)` without `.relativeTo` or `.scaled` modifier
- [ ] Dynamic Type scaling is applied (test at AX5 — largest size)

### Spacing & Layout
- [ ] All gaps use `DSSpacing` constants (space4, space8, space16, etc.)
- [ ] All corner radii use `DSRadius` constants (small, medium, large, full)
- [ ] ❌ No magic numbers (15, 20, 24) hardcoded in padding/spacing

### Haptics
- [ ] Haptic events are user-initiated only (not automatic, not scroll-based)
- [ ] ❌ No chained haptics within 100 ms
- [ ] Haptic intensity/sharpness matches event semantics
- [ ] Disabled controls do not trigger haptics

### Animations
- [ ] All animations use `.spring()` (not `.easeInOut()` except for carousel transitions)
- [ ] Spring parameters match documented curves (snappy, standard, expressive, reveal, gentle)
- [ ] Reduce-motion is respected (fade fallback or removed when appropriate)
- [ ] ❌ No `.animation(.default)` or `.animation(nil)`

### Accessibility
- [ ] All interactive elements are 44×44 pt min (measured in Xcode preview or device test)
- [ ] All buttons/controls have `accessibilityLabel`
- [ ] Complex states have `accessibilityValue` and/or `accessibilityHint`
- [ ] VoiceOver testing: navigate all interactive elements, read content, verify order
- [ ] Reduced motion: test at Settings > Accessibility > Motion > Reduce Motion

### Dark Mode Only
- [ ] No light mode colors in components (not needed for dark-mode-only app)
- [ ] Colors are verified on dark background (#000011 for base)
- [ ] No hardcoded `.white` or `.black` (use design system colors)

---

## Code Review Checklist

### File Organization
- [ ] Component is in `@Groupool/Packages/DesignSystem`
- [ ] Related modifiers are in `Tokens/` directory (if applicable)
- [ ] No components duplicated across packages
- [ ] Component imports only necessary dependencies (SwiftUI, Kingfisher if needed)

### MVVM Compliance
- [ ] ViewModel owns business logic
- [ ] View owns presentation logic only (no if/else for validation)
- [ ] No data fetching in View init or body
- [ ] Data fetching in `.task { }` or `.onAppear { }`

### Performance
- [ ] Views ≤ 20 lines (subviews extracted if exceeded)
- [ ] No computed properties with side effects
- [ ] `.equatable()` applied to complex leaf views (if appropriate)
- [ ] Explicit stable IDs in ForEach (no indices)
- [ ] ❌ No `AnyView` unless return type is truly opaque

### State Management
- [ ] `@State` used only for local UI state (animations, toggles, sheets)
- [ ] `@ObservedObject` / `@StateObject` used for ViewModel instances
- [ ] Bindings flow downward (parent owns source of truth)
- [ ] ❌ No two-way bindings or bidirectional updates

### Testing
- [ ] Component is previewed in `DesignSystemPreviews.swift`
- [ ] Preview includes all states (idle, loading, success, error)
- [ ] Preview tested on device (not just simulator)
- [ ] Preview tested at AX5 (largest text size)

---

## Live Device Testing

### Before Handoff
1. [ ] Run on iPhone (physical device, iOS 15+)
2. [ ] Test all states: idle, loading, success, error
3. [ ] Test tap interactions (haptics should fire)
4. [ ] Test keyboard (if text input)
5. [ ] Test with VoiceOver enabled:
   - [ ] Navigate with swipe gestures
   - [ ] Verify all labels are read
   - [ ] Verify state changes are announced
6. [ ] Test with Reduce Motion enabled:
   - [ ] No jarring layout jumps
   - [ ] Fallback animations are smooth
7. [ ] Test on light and dark system appearance (app is dark-mode only, but system light mode should not break layout)
8. [ ] Test on smallest and largest text sizes (Accessibility settings)
9. [ ] Test with low battery mode (haptics may be affected)

### Performance
1. [ ] No lag on scroll (if component is in list)
2. [ ] Smooth animation transitions
3. [ ] No memory leaks (Xcode profiler / Memory Graph)
4. [ ] No battery drain from timers or background work

---

## Documentation Checklist

For each component added to design system:

- [ ] Entry in `COMPONENTS.md` with:
  - [ ] When to use / when NOT to use
  - [ ] Interface signature (struct definition)
  - [ ] Styling rules (colors, fonts, spacing)
  - [ ] State behavior (if ViewState-aware)
  - [ ] Haptic mapping (if applicable)
  - [ ] Animation constraints
  - [ ] Implementation notes
  - [ ] Example code
- [ ] Added to `DesignSystemPreviews.swift` with all states
- [ ] All public initializers documented
- [ ] Migration guide if replacing existing component

---

## Sign-Off

- [ ] All checklist items completed
- [ ] Code review approved by Design Systems lead
- [ ] Live device testing passed
- [ ] Documentation updated
- [ ] Component added to design system package
- [ ] PR merged to main
- [ ] Version bump in `Package.swift`

**Tested by:** ________________
**Date:** ________________
**Notes:** ________________

---

**Last updated:** 2026-04-02
