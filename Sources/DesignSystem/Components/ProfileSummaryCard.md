# ProfileSummaryCard

## Purpose
`ProfileSummaryCard` provides the Home profile summary UI block as a reusable DesignSystem component.

## Content
- Tappable avatar with URL image support and initials fallback.
- Display name and status badge.
- Inline profile stats row:
  - Challenges Won
  - Lost
  - Reliability
- Reputation label.
- Action link rows:
  - Edit Profile
  - PIX Keys
  - App Settings
  - Log Out

## Behavior
- The component is presentation-only.
- Navigation and logout behavior are delegated through `onAvatarTap` and `onActionTap`.
