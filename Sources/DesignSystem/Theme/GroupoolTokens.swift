import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public enum GroupoolSpacing {
    public static let xxxs: CGFloat = 4
    public static let xxs: CGFloat = 6
    public static let xs: CGFloat = 8
    public static let sm: CGFloat = 10
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 14
    public static let xl: CGFloat = 16
    public static let xxl: CGFloat = 18
    public static let xxxl: CGFloat = 20
    public static let section: CGFloat = 24
}

public enum GroupoolRadius {
    public static func small(for theme: GroupoolTheme = .default) -> CGFloat {
        switch theme.softness {
        case .sharp: 4
        case .medium: 10
        case .bubbly: 16
        }
    }

    public static func medium(for theme: GroupoolTheme = .default) -> CGFloat {
        switch theme.softness {
        case .sharp: 8
        case .medium: 18
        case .bubbly: 26
        }
    }

    public static func large(for theme: GroupoolTheme = .default) -> CGFloat {
        switch theme.softness {
        case .sharp: 14
        case .medium: 28
        case .bubbly: 40
        }
    }

    public static func extraLarge(for theme: GroupoolTheme = .default) -> CGFloat {
        switch theme.softness {
        case .sharp: 18
        case .medium: 36
        case .bubbly: 56
        }
    }
}

public enum GroupoolTypography {
    public enum Role {
        case displayXL
        case displayL
        case displayM
        case title
        case body
        case bodyStrong
        case caption
        case label
        case mono

        var size: CGFloat {
            switch self {
            case .displayXL: 56
            case .displayL: 44
            case .displayM: 28
            case .title: 20
            case .body: 15
            case .bodyStrong: 17
            case .caption: 12
            case .label: 11
            case .mono: 12
            }
        }

        var weight: Font.Weight {
            switch self {
            case .displayXL, .displayL, .displayM: .medium
            case .title: .bold
            case .body: .regular
            case .bodyStrong: .semibold
            case .caption: .medium
            case .label: .semibold
            case .mono: .medium
            }
        }

        var textStyle: Font.TextStyle {
            switch self {
            case .displayXL: .largeTitle
            case .displayL: .largeTitle
            case .displayM: .title
            case .title: .title3
            case .body: .body
            case .bodyStrong: .headline
            case .caption: .caption
            case .label: .caption2
            case .mono: .caption
            }
        }
    }

    public static func font(_ role: Role, theme: GroupoolTheme = .default) -> Font {
        let descriptor = descriptor(for: role, theme: theme)
        if isFontAvailable(named: descriptor.name, size: descriptor.size) {
            return .custom(descriptor.name, size: descriptor.size, relativeTo: role.textStyle)
        }
        return .system(size: descriptor.size, weight: descriptor.weight, design: descriptor.design)
    }

    public static func tracking(for role: Role) -> CGFloat {
        switch role {
        case .displayXL, .displayL, .displayM: -0.8
        case .title, .body, .bodyStrong: -0.2
        case .caption: 0.1
        case .label: 1.0
        case .mono: 0
        }
    }

    private static func descriptor(for role: Role, theme: GroupoolTheme) -> (name: String, size: CGFloat, weight: Font.Weight, design: Font.Design) {
        let size = role.size
        let weight = role.weight
        switch role {
        case .mono:
            return ("JetBrains Mono", size, weight, .monospaced)
        case .displayXL, .displayL, .displayM:
            switch theme.fonts {
            case .serifSans:
                return ("Fraunces", size, weight, .serif)
            case .sansSans:
                return ("Inter", size, weight, .default)
            case .monoSans:
                return ("JetBrains Mono", size, weight, .monospaced)
            case .displaySans:
                return ("Instrument Serif", size, weight, .serif)
            }
        case .title, .body, .bodyStrong, .caption, .label:
            return ("Inter", size, weight, .default)
        }
    }

    private static func isFontAvailable(named name: String, size: CGFloat) -> Bool {
        #if canImport(UIKit)
        return UIFont(name: name, size: size) != nil
        #elseif canImport(AppKit)
        return NSFont(name: name, size: size) != nil
        #else
        return false
        #endif
    }
}

public extension Color {
    static let groupoolBackground = Color("Background", bundle: .module)
    static let groupoolSurface = Color("Surface", bundle: .module)
    static let groupoolInk = Color("Ink", bundle: .module)
    static let groupoolInkSecondary = Color("InkSecondary", bundle: .module)
    static let groupoolInkTertiary = Color("InkTertiary", bundle: .module)
    static let groupoolLine = Color("Line", bundle: .module)
    static let groupoolLineSecondary = Color("LineSecondary", bundle: .module)
    static let groupoolWood = Color("Wood", bundle: .module)
    static let groupoolWoodDark = Color("WoodDark", bundle: .module)
    static let groupoolGood = Color("Good", bundle: .module)
    static let groupoolWarning = Color("Warning", bundle: .module)
    static let groupoolBad = Color("Bad", bundle: .module)
    static let groupoolPoolBlue = Color("PoolBlue", bundle: .module)
    static let groupoolPoolBlueDeep = Color("PoolBlueDeep", bundle: .module)
    static let groupoolPoolBlueSoft = Color("PoolBlueSoft", bundle: .module)
    static let groupoolPoolTeal = Color("PoolTeal", bundle: .module)
    static let groupoolPoolTealDeep = Color("PoolTealDeep", bundle: .module)
    static let groupoolPoolTealSoft = Color("PoolTealSoft", bundle: .module)
    static let groupoolPoolCoral = Color("PoolCoral", bundle: .module)
    static let groupoolPoolCoralDeep = Color("PoolCoralDeep", bundle: .module)
    static let groupoolPoolCoralSoft = Color("PoolCoralSoft", bundle: .module)
    static let groupoolPoolViolet = Color("PoolViolet", bundle: .module)
    static let groupoolPoolVioletDeep = Color("PoolVioletDeep", bundle: .module)
    static let groupoolPoolVioletSoft = Color("PoolVioletSoft", bundle: .module)
    static let groupoolPoolLime = Color("PoolLime", bundle: .module)
    static let groupoolPoolLimeDeep = Color("PoolLimeDeep", bundle: .module)
    static let groupoolPoolLimeSoft = Color("PoolLimeSoft", bundle: .module)
}

public extension GroupoolTheme {
    var background: Color { mode == .light ? .groupoolBackground : Color(hex: "#151210") }
    var surface: Color { mode == .light ? .groupoolSurface : Color(hex: "#221E19") }
    var ink: Color { mode == .light ? .groupoolInk : Color(hex: "#F4EEE0") }
    var inkSecondary: Color { mode == .light ? .groupoolInkSecondary : Color(hex: "#A89E8A") }
    var inkTertiary: Color { mode == .light ? .groupoolInkTertiary : Color(hex: "#6B6455") }
    var line: Color { mode == .light ? .groupoolLine : Color(hex: "#2E2822") }
    var lineSecondary: Color { mode == .light ? .groupoolLineSecondary : Color(hex: "#3D362D") }
    var wood: Color { .groupoolWood }
    var woodDark: Color { .groupoolWoodDark }
    var good: Color { .groupoolGood }
    var warning: Color { .groupoolWarning }
    var bad: Color { .groupoolBad }
    var pool: Color { accent.color }
    var poolDeep: Color { accent.deepColor }
    var poolSoft: Color {
        if mode == .dark, accent == .blue {
            return Color(hex: "#1A2A3E")
        }
        return accent.softColor
    }
}

public extension Color {
    init(hex: String) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        let value = Int(cleaned, radix: 16) ?? 0
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}
