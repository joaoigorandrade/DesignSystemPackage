# DSGIFView

Reusable local GIF handler for DesignSystem components.

---

## Usage

### Default looping GIF

```swift
DSGIFView(gifName: "loading-screen")
    .frame(width: 160, height: 160)
```

### Custom bundle and content mode

```swift
DSGIFView(
    gifName: "success-state",
    bundle: .main,
    contentMode: .scaleAspectFit
)
.frame(width: 120, height: 120)
```

### Fallback behavior

When the local `.gif` file cannot be found, `DSGIFView` automatically renders a branded `ProgressView` fallback.
