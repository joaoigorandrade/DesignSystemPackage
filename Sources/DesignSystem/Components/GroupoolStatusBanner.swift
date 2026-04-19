import SwiftUI

public enum GroupoolStatusBannerKind: CaseIterable, Sendable {
    case observer
    case inactive
    case debt
    case warning
    case success

    var icon: String {
        switch self {
        case .observer: "eye"
        case .inactive: "clock"
        case .debt: "flag"
        case .warning: "exclamationmark"
        case .success: "check"
        }
    }
}

public struct GroupoolStatusBanner<Content: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let kind: GroupoolStatusBannerKind
    private let content: Content

    public init(_ kind: GroupoolStatusBannerKind, @ViewBuilder content: () -> Content) {
        self.kind = kind
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            GroupoolIcon(kind.icon, size: 18, color: foregroundColor)
            content
                .groupoolTextStyle(.body, color: foregroundColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous))
    }

    private var backgroundColor: Color {
        switch kind {
        case .observer: .groupoolPoolVioletSoft
        case .inactive: theme.line
        case .debt: .groupoolPoolCoralSoft
        case .warning: theme.warning.opacity(0.15)
        case .success: theme.good.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch kind {
        case .observer: .groupoolPoolVioletDeep
        case .inactive: theme.inkSecondary
        case .debt: theme.bad
        case .warning: theme.warning
        case .success: theme.good
        }
    }
}
