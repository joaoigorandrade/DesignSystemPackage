import SwiftUI

public struct GroupoolButtonStyle: ButtonStyle {
    public enum Variant: Sendable {
        case primary
        case pool
        case ghost
        case subtle
    }

    public enum Size: Sendable {
        case regular
        case small
    }

    @Environment(\.groupoolTheme) private var theme

    private let variant: Variant
    private let size: Size
    private let fullWidth: Bool

    public init(variant: Variant = .primary, size: Size = .regular, fullWidth: Bool = false) {
        self.variant = variant
        self.size = size
        self.fullWidth = fullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .groupoolTextStyle(size == .small ? .caption : .bodyStrong, color: foregroundColor)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: size == .small ? 38 : 54)
            .padding(.horizontal, size == .small ? 14 : 22)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary: theme.ink
        case .pool: theme.pool
        case .ghost: .clear
        case .subtle: theme.surface
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: theme.background
        case .pool: .white
        case .ghost, .subtle: theme.ink
        }
    }

    private var borderColor: Color {
        switch variant {
        case .ghost: theme.lineSecondary
        case .subtle: theme.line
        case .primary, .pool: .clear
        }
    }

    private var borderWidth: CGFloat {
        switch variant {
        case .ghost: 1.5
        case .subtle: 1
        case .primary, .pool: 0
        }
    }

    private var cornerRadius: CGFloat {
        size == .small ? GroupoolRadius.medium(for: theme) : GroupoolRadius.large(for: theme)
    }
}

public extension ButtonStyle where Self == GroupoolButtonStyle {
    static func groupool(
        _ variant: GroupoolButtonStyle.Variant = .primary,
        size: GroupoolButtonStyle.Size = .regular,
        fullWidth: Bool = false
    ) -> GroupoolButtonStyle {
        GroupoolButtonStyle(variant: variant, size: size, fullWidth: fullWidth)
    }
}
