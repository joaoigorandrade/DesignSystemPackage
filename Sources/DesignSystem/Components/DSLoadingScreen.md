# DSLoadingScreen

Centralized GIF loading screen for blocking loading states.

---

## Architecture

| Layer | Responsibility |
|-------|---------------|
| `DSLoadingScreen` | Public entry point - composes layout and routes local GIF source |
| `DSGIFView` | Renders bundled `.gif` animation or falls back to `ProgressView` |
| `LoadingMessageView` | Renders the optional subtitle below the animation |
| `.dsLoadingOverlay(isLoading:gifName:bundle:message:)` | `View` extension for inline overlay usage |

---

## Usage

### Full-screen loading (default local GIF)

```swift
DSLoadingScreen(message: "Loading your groups...")
```

### Full-screen loading (specific local bundled GIF)

Place the `.gif` file inside the app target or DesignSystem resources and reference it by name:

```swift
DSLoadingScreen.local("splash_loading", message: "Almost there...")
```

### Overlay on existing content

```swift
MyContentView()
    .dsLoadingOverlay(
        isLoading: viewModel.isLoading,
        gifName: "loading-screen",
        message: "Syncing..."
    )
```

### Missing GIF fallback

If the animation cannot be resolved, a `ProgressView` spinner is shown instead.

```swift
DSLoadingScreen(gifName: "missing-animation")
```

---

## Design Tokens

| Element | Token |
|---------|-------|
| Background | `Color.backgroundGrey` |
| Fallback spinner tint | `Color.brandPrimary` |
| Message text style | `.dsBody()` |
| Message text color | `Color.coolGrey` |
