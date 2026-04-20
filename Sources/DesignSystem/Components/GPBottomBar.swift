import SwiftUI

public struct GPBottomBar<Content: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(theme.line)
                .frame(height: 1)

            content
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(theme.background.opacity(0.96))
        .background(.ultraThinMaterial)
    }
}
