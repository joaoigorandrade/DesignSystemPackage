import SwiftUI

public enum GPColors {
    public static func background(_ theme: GroupoolTheme = .default) -> Color { theme.background }
    public static func surface(_ theme: GroupoolTheme = .default) -> Color { theme.surface }
    public static func ink(_ theme: GroupoolTheme = .default) -> Color { theme.ink }
    public static func ink2(_ theme: GroupoolTheme = .default) -> Color { theme.inkSecondary }
    public static func ink3(_ theme: GroupoolTheme = .default) -> Color { theme.inkTertiary }
    public static func line(_ theme: GroupoolTheme = .default) -> Color { theme.line }
    public static func line2(_ theme: GroupoolTheme = .default) -> Color { theme.lineSecondary }
    public static func pool(_ theme: GroupoolTheme = .default) -> Color { theme.pool }
    public static func poolDeep(_ theme: GroupoolTheme = .default) -> Color { theme.poolDeep }
    public static func poolSoft(_ theme: GroupoolTheme = .default) -> Color { theme.poolSoft }
    public static func wood(_ theme: GroupoolTheme = .default) -> Color { theme.wood }
    public static func woodDark(_ theme: GroupoolTheme = .default) -> Color { theme.woodDark }
    public static func good(_ theme: GroupoolTheme = .default) -> Color { theme.good }
    public static func warn(_ theme: GroupoolTheme = .default) -> Color { theme.warning }
    public static func bad(_ theme: GroupoolTheme = .default) -> Color { theme.bad }

    public static func accentColor(_ accent: GroupoolTheme.Accent) -> Color { accent.color }
    public static func accentDeep(_ accent: GroupoolTheme.Accent) -> Color { accent.deepColor }
    public static func accentSoft(_ accent: GroupoolTheme.Accent) -> Color { accent.softColor }

    public static let teal = GroupoolTheme.Accent.teal.color
    public static let tealDeep = GroupoolTheme.Accent.teal.deepColor
    public static let tealSoft = GroupoolTheme.Accent.teal.softColor

    public static let coral = GroupoolTheme.Accent.coral.color
    public static let coralDeep = GroupoolTheme.Accent.coral.deepColor
    public static let coralSoft = GroupoolTheme.Accent.coral.softColor

    public static let violet = GroupoolTheme.Accent.violet.color
    public static let violetDeep = GroupoolTheme.Accent.violet.deepColor
    public static let violetSoft = GroupoolTheme.Accent.violet.softColor

    public static let lime = GroupoolTheme.Accent.lime.color
    public static let limeDeep = GroupoolTheme.Accent.lime.deepColor
    public static let limeSoft = GroupoolTheme.Accent.lime.softColor
}
