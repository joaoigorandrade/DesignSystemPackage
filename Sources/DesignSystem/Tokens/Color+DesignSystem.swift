import SwiftUI

public extension Color {

    // MARK: - Brand

    static let brandPrimary = Color("BrandPrimary", bundle: .module)
    static let brandSecondary = Color("BrandSecondary", bundle: .module)

    // MARK: - Semantic

    static let success = Color("Success", bundle: .module)
    static let danger = Color("Danger", bundle: .module)
    static let warning = Color("Warning", bundle: .module)
    static let info = Color("Info", bundle: .module)

    // MARK: - Backgrounds

    static let backgroundBase = Color("BackgroundGrey", bundle: .module)
    static let backgroundElevated = Color("BackgroundElevated", bundle: .module)
    static let backgroundTop = Color("BackgroundTop", bundle: .module)

    // MARK: - Text

    static let textPrimary = Color("TextPrimary", bundle: .module)
    static let textSecondary = Color("TextSecondary", bundle: .module)
    static let textTertiary = Color("TextTertiary", bundle: .module)

    // MARK: - Borders

    static let borderDefault = Color("BorderDefault", bundle: .module)
    static let borderSubtle = Color("BorderSubtle", bundle: .module)

    // MARK: - Legacy

    static let vibrantOrange = Color("VibrantOrange", bundle: .module)
    static let coolGrey = Color("CoolGrey", bundle: .module)
    static let backgroundGrey = Color("BackgroundGrey", bundle: .module)
}
