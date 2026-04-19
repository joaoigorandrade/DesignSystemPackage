import SwiftUI

public struct GroupoolTextStyleModifier: ViewModifier {
    @Environment(\.groupoolTheme) private var theme

    private let role: GroupoolTypography.Role
    private let color: Color?

    public init(_ role: GroupoolTypography.Role, color: Color? = nil) {
        self.role = role
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .font(GroupoolTypography.font(role, theme: theme))
            .tracking(GroupoolTypography.tracking(for: role))
            .foregroundStyle(color ?? theme.ink)
    }
}

public extension View {
    func groupoolTextStyle(_ role: GroupoolTypography.Role, color: Color? = nil) -> some View {
        modifier(GroupoolTextStyleModifier(role, color: color))
    }
}
