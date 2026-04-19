import SwiftUI

public struct GroupoolCard<Content: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let padding: CGFloat
    private let content: Content

    public init(padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: GroupoolRadius.large(for: theme), style: .continuous)
                    .stroke(theme.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.large(for: theme), style: .continuous))
    }
}

public struct GroupoolSectionHeader: View {
    @Environment(\.groupoolTheme) private var theme

    private let title: String
    private let trailing: String?

    public init(_ title: String, trailing: String? = nil) {
        self.title = title
        self.trailing = trailing
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title.uppercased())
                .groupoolTextStyle(.caption, color: theme.inkSecondary)
                .fontWeight(.bold)
            Spacer()
            if let trailing {
                Text(trailing)
                    .groupoolTextStyle(.caption, color: theme.inkTertiary)
            }
        }
    }
}

public struct GroupoolListRow<Leading: View, Content: View, Trailing: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let leading: Leading
    private let content: Content
    private let trailing: Trailing
    private let showsDivider: Bool

    public init(
        showsDivider: Bool = true,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.leading = leading()
        self.content = content()
        self.trailing = trailing()
        self.showsDivider = showsDivider
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                leading
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                trailing
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            if showsDivider {
                Divider()
                    .overlay(theme.line)
                    .padding(.leading, 64)
            }
        }
        .background(theme.surface)
    }
}
