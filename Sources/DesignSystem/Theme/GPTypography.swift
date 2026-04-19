import SwiftUI

public enum GPTypography {
    public static func gpDisplay(_ size: CGFloat, theme: GroupoolTheme = .default) -> Font {
        GroupoolTypography.font(displayRole(for: size), theme: theme)
    }

    public static func gpUI(_ size: CGFloat) -> Font {
        GroupoolTypography.font(uiRole(for: size))
    }

    public static func gpMono(_ size: CGFloat) -> Font {
        GroupoolTypography.font(.mono)
    }

    private static func displayRole(for size: CGFloat) -> GroupoolTypography.Role {
        switch size {
        case ..<14: .caption
        case ..<16: .body
        case ..<22: .title
        case ..<32: .displayM
        case ..<48: .displayL
        default: .displayXL
        }
    }

    private static func uiRole(for size: CGFloat) -> GroupoolTypography.Role {
        switch size {
        case ..<12: .caption
        case ..<14: .label
        case ..<16: .body
        case ..<18: .bodyStrong
        default: .title
        }
    }
}

public extension View {
    func gpDisplay(size: CGFloat, color: Color? = nil) -> some View {
        modifier(GPDisplayModifier(size: size, color: color))
    }

    func gpUI(size: CGFloat, color: Color? = nil) -> some View {
        modifier(GPUIModifier(size: size, color: color))
    }

    func gpMono(size: CGFloat = 12, color: Color? = nil) -> some View {
        modifier(GPMonoModifier(size: size, color: color))
    }
}

private struct GPDisplayModifier: ViewModifier {
    @Environment(\.groupoolTheme) private var theme
    let size: CGFloat
    let color: Color?

    func body(content: Content) -> some View {
        content
            .font(GPTypography.gpDisplay(size, theme: theme))
            .foregroundStyle(color ?? theme.ink)
    }
}

private struct GPUIModifier: ViewModifier {
    @Environment(\.groupoolTheme) private var theme
    let size: CGFloat
    let color: Color?

    func body(content: Content) -> some View {
        content
            .font(GPTypography.gpUI(size))
            .foregroundStyle(color ?? theme.ink)
    }
}

private struct GPMonoModifier: ViewModifier {
    @Environment(\.groupoolTheme) private var theme
    let size: CGFloat
    let color: Color?

    func body(content: Content) -> some View {
        content
            .font(GPTypography.gpMono(size))
            .foregroundStyle(color ?? theme.ink)
    }
}
