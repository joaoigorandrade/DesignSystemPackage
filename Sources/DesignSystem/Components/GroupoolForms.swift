import SwiftUI

public struct GroupoolFormLabel: View {
    @Environment(\.groupoolTheme) private var theme

    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text.uppercased())
            .groupoolTextStyle(.label, color: theme.inkTertiary)
            .padding(.top, 18)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public struct GroupoolInputField<Leading: View, Trailing: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let title: String?
    @Binding private var text: String
    private let prompt: String
    private let isMultiline: Bool
    private let isLarge: Bool
    private let leading: Leading
    private let trailing: Trailing

    public init(
        title: String? = nil,
        text: Binding<String>,
        prompt: String = "",
        isMultiline: Bool = false,
        isLarge: Bool = false,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.isMultiline = isMultiline
        self.isLarge = isLarge
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title {
                GroupoolFormLabel(title)
            }
            HStack(alignment: isMultiline ? .top : .center, spacing: 6) {
                leading
                    .groupoolTextStyle(.bodyStrong, color: theme.inkTertiary)
                if isMultiline {
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 84)
                        .font(uiFont)
                        .foregroundStyle(theme.ink)
                } else {
                    TextField(prompt, text: $text)
                        .font(uiFont)
                        .foregroundStyle(theme.ink)
                }
                trailing
                    .groupoolTextStyle(.body, color: theme.inkTertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, isMultiline ? 12 : 14)
            .background(theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                    .stroke(theme.line, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous))
        }
    }

    private var uiFont: Font {
        isLarge ? GroupoolTypography.font(.displayM, theme: theme) : GroupoolTypography.font(.bodyStrong, theme: theme)
    }
}
