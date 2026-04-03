import SwiftUI

public struct DSNavigationBar<LeadingContent: View, TrailingContent: View>: View {
    public let title: String
    public let subtitle: String?
    public let displayMode: DisplayMode
    public let leadingContent: LeadingContent
    public let trailingContent: TrailingContent

    public enum DisplayMode {
        case inline
        case large
    }

    public init(
        title: String,
        subtitle: String? = nil,
        displayMode: DisplayMode = .inline,
        @ViewBuilder leading: () -> LeadingContent,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.displayMode = displayMode
        self.leadingContent = leading()
        self.trailingContent = trailing()
    }

    public var body: some View {
        VStack(spacing: 0) {
            if displayMode == .large {
                largeLayout
            } else {
                inlineLayout
            }

            Divider()
                .overlay(Color.borderSubtle)
        }
        .background(Color.backgroundBase.opacity(0.85))
        .background(.ultraThinMaterial)
    }

    // MARK: - Inline

    private var inlineLayout: some View {
        HStack(spacing: DSSpacing.space16) {
            leadingContent
                .frame(minWidth: 44, minHeight: 44)

            Spacer()

            VStack(spacing: DSSpacing.space2) {
                Text(title)
                    .dsHeadline()
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                if let subtitle {
                    Text(subtitle)
                        .dsCaption()
                        .foregroundColor(.textTertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            trailingContent
                .frame(minWidth: 44, minHeight: 44)
        }
        .padding(.horizontal, DSSpacing.space20)
        .frame(minHeight: 44)
        .padding(.vertical, DSSpacing.space8)
    }

    // MARK: - Large

    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: DSSpacing.space8) {
            HStack(spacing: DSSpacing.space16) {
                leadingContent
                    .frame(minWidth: 44, minHeight: 44)

                Spacer()

                trailingContent
                    .frame(minWidth: 44, minHeight: 44)
            }

            Text(title)
                .dsLargeTitle()
                .foregroundColor(.textPrimary)

            if let subtitle {
                Text(subtitle)
                    .dsSubheadline()
                    .foregroundColor(.textSecondary)
            }
        }
        .padding(.horizontal, DSSpacing.space20)
        .padding(.bottom, DSSpacing.space8)
    }
}

// MARK: - Convenience Initializers

public extension DSNavigationBar where LeadingContent == EmptyView, TrailingContent == EmptyView {
    init(title: String, subtitle: String? = nil, displayMode: DisplayMode = .inline) {
        self.init(title: title, subtitle: subtitle, displayMode: displayMode, leading: { EmptyView() }, trailing: { EmptyView() })
    }
}

public extension DSNavigationBar where TrailingContent == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        displayMode: DisplayMode = .inline,
        @ViewBuilder leading: () -> LeadingContent
    ) {
        self.init(title: title, subtitle: subtitle, displayMode: displayMode, leading: leading, trailing: { EmptyView() })
    }
}

public extension DSNavigationBar where LeadingContent == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        displayMode: DisplayMode = .inline,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.init(title: title, subtitle: subtitle, displayMode: displayMode, leading: { EmptyView() }, trailing: trailing)
    }
}

// MARK: - Navigation Bar Button

public struct DSNavBarButton: View {
    public let icon: BrandIcon
    public let action: () -> Void

    public init(icon: BrandIcon, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            icon.view(scale: .large)
                .foregroundColor(.brandPrimary)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
    }
}
