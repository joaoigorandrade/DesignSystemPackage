import SwiftUI

public struct GroupoolTheme: Equatable, Sendable {
    public enum Accent: String, CaseIterable, Sendable {
        case blue
        case teal
        case coral
        case violet
        case lime

        public var color: Color {
            switch self {
            case .blue: .groupoolPoolBlue
            case .teal: .groupoolPoolTeal
            case .coral: .groupoolPoolCoral
            case .violet: .groupoolPoolViolet
            case .lime: .groupoolPoolLime
            }
        }

        public var deepColor: Color {
            switch self {
            case .blue: .groupoolPoolBlueDeep
            case .teal: .groupoolPoolTealDeep
            case .coral: .groupoolPoolCoralDeep
            case .violet: .groupoolPoolVioletDeep
            case .lime: .groupoolPoolLimeDeep
            }
        }

        public var softColor: Color {
            switch self {
            case .blue: .groupoolPoolBlueSoft
            case .teal: .groupoolPoolTealSoft
            case .coral: .groupoolPoolCoralSoft
            case .violet: .groupoolPoolVioletSoft
            case .lime: .groupoolPoolLimeSoft
            }
        }
    }

    public enum Softness: String, CaseIterable, Sendable {
        case sharp
        case medium
        case bubbly
    }

    public enum FontPreset: String, CaseIterable, Sendable {
        case serifSans
        case sansSans
        case monoSans
        case displaySans
    }

    public enum Mode: String, CaseIterable, Sendable {
        case light
        case dark
    }

    public var accent: Accent
    public var softness: Softness
    public var fonts: FontPreset
    public var mode: Mode

    public init(
        accent: Accent = .blue,
        softness: Softness = .medium,
        fonts: FontPreset = .serifSans,
        mode: Mode = .light
    ) {
        self.accent = accent
        self.softness = softness
        self.fonts = fonts
        self.mode = mode
    }

    public static let `default` = GroupoolTheme()
}

private struct GroupoolThemeKey: EnvironmentKey {
    static let defaultValue = GroupoolTheme.default
}

public extension EnvironmentValues {
    var groupoolTheme: GroupoolTheme {
        get { self[GroupoolThemeKey.self] }
        set { self[GroupoolThemeKey.self] = newValue }
    }
}

public extension View {
    func groupoolTheme(_ theme: GroupoolTheme) -> some View {
        environment(\.groupoolTheme, theme)
    }
}
