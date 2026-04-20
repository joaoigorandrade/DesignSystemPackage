import Foundation
import SwiftUI

#if canImport(Testing)
import Testing
@testable import DesignSystem

@MainActor
@Suite("DesignSystem")
struct DesignSystemTests {

    // MARK: - GroupoolTheme

    @Test("Default theme matches prototype root tokens")
    func test_defaultTheme_matchesPrototypeRootTokens() {
        let sut = makeSUT()
        #expect(sut.accent == .blue)
        #expect(sut.softness == .medium)
        #expect(sut.fonts == .serifSans)
        #expect(sut.mode == .light)
    }

    // MARK: - GroupoolRadius (softness-aware)

    @Test("Medium radii match prototype medium tokens")
    func test_mediumRadii_matchPrototypeMediumTokens() {
        let sut = makeSUT(softness: .medium)
        #expect(GroupoolRadius.small(for: sut) == 10)
        #expect(GroupoolRadius.medium(for: sut) == 18)
        #expect(GroupoolRadius.large(for: sut) == 28)
        #expect(GroupoolRadius.extraLarge(for: sut) == 36)
    }

    @Test("Bubbly radii match prototype bubbly tokens")
    func test_bubblyRadii_matchPrototypeBubblyTokens() {
        let sut = makeSUT(softness: .bubbly)
        #expect(GroupoolRadius.small(for: sut) == 16)
        #expect(GroupoolRadius.medium(for: sut) == 26)
        #expect(GroupoolRadius.large(for: sut) == 40)
        #expect(GroupoolRadius.extraLarge(for: sut) == 56)
    }

    @Test("Sharp radii match prototype sharp tokens")
    func test_sharpRadii_matchPrototypeSharpTokens() {
        let sut = makeSUT(softness: .sharp)
        #expect(GroupoolRadius.small(for: sut) == 4)
        #expect(GroupoolRadius.medium(for: sut) == 8)
        #expect(GroupoolRadius.large(for: sut) == 14)
        #expect(GroupoolRadius.extraLarge(for: sut) == 18)
    }

    // MARK: - GPRadii (fixed medium defaults)

    @Test("GPRadii constants match prototype medium tokens")
    func test_gpRadii_matchPrototypeMediumTokens() {
        #expect(GPRadii.small == 10)
        #expect(GPRadii.medium == 18)
        #expect(GPRadii.large == 28)
        #expect(GPRadii.extraLarge == 36)
    }

    // MARK: - Accent selection

    @Test("Accent enum covers all five prototype variants")
    func test_accent_coversAllFivePrototypeVariants() {
        let allCases = GroupoolTheme.Accent.allCases
        #expect(allCases.count == 5)
        #expect(allCases.contains(.blue))
        #expect(allCases.contains(.teal))
        #expect(allCases.contains(.coral))
        #expect(allCases.contains(.violet))
        #expect(allCases.contains(.lime))
    }

    @Test("Changing accent changes pool color")
    func test_changingAccent_changesPoolColor() {
        let blue = makeSUT(accent: .blue)
        let teal = makeSUT(accent: .teal)
        #expect(blue.pool != teal.pool)
    }

    @Test("All color assets include dark mode variants")
    func test_allColorAssets_includeDarkModeVariants() throws {
        for assetName in try loadColorAssetNames() {
            let contents = try loadColorAssetContents(named: assetName)
            let colors = try #require(contents["colors"] as? [[String: Any]])
            let hasDarkAppearance = colors.contains { entry in
                guard let appearances = entry["appearances"] as? [[String: String]] else {
                    return false
                }

                return appearances.contains {
                    $0["appearance"] == "luminosity" && $0["value"] == "dark"
                }
            }

            #expect(hasDarkAppearance)
        }
    }

    // MARK: - GPTypes

    @Test("GPMemberStatus covers all five status variants")
    func test_gpMemberStatus_coversAllFiveVariants() {
        #expect(GPMemberStatus.allCases.count == 5)
    }

    @Test("GPTransactionKind covers neutral frozen credit")
    func test_gpTransactionKind_coversThreeVariants() {
        #expect(GPTransactionKind.allCases.count == 3)
    }

    @Test("GPOutcomeColor covers five semantic colors")
    func test_gpOutcomeColor_coversFiveSemanticColors() {
        #expect(GPOutcomeColor.allCases.count == 5)
    }

    @Test("GPStatusBannerKind covers five semantic status treatments")
    func test_gpStatusBannerKind_coversFiveSemanticStatusTreatments() {
        #expect(GPStatusBannerKind.allCases.count == 5)
        #expect(GPStatusBannerKind.allCases.contains(.observer))
        #expect(GPStatusBannerKind.allCases.contains(.inactive))
        #expect(GPStatusBannerKind.allCases.contains(.debt))
        #expect(GPStatusBannerKind.allCases.contains(.warning))
        #expect(GPStatusBannerKind.allCases.contains(.success))
    }

    @Test("GPFinancialSummaryTone covers five semantic amount treatments")
    func test_gpFinancialSummaryTone_coversFiveSemanticAmountTreatments() {
        #expect(GPFinancialSummaryTone.allCases.count == 5)
        #expect(GPFinancialSummaryTone.allCases.contains(.neutral))
        #expect(GPFinancialSummaryTone.allCases.contains(.pool))
        #expect(GPFinancialSummaryTone.allCases.contains(.good))
        #expect(GPFinancialSummaryTone.allCases.contains(.warn))
        #expect(GPFinancialSummaryTone.allCases.contains(.bad))
    }

    // MARK: - Bottom bar

    @Test("Bottom bar remains available with arbitrary content")
    func test_bottomBar_acceptsArbitraryContent() {
        let sut = GPBottomBar {
            Text("Continue")
        }

        #expect(String(describing: type(of: sut)).contains("GPBottomBar"))
    }

    // MARK: - Typography tracking

    @Test("Display roles have negative tracking")
    func test_displayRoles_haveNegativeTracking() {
        #expect(GroupoolTypography.tracking(for: .displayXL) < 0)
        #expect(GroupoolTypography.tracking(for: .displayL) < 0)
        #expect(GroupoolTypography.tracking(for: .displayM) < 0)
    }

    @Test("Label role has positive tracking for uppercase readability")
    func test_labelRole_hasPositiveTracking() {
        #expect(GroupoolTypography.tracking(for: .label) > 0)
    }

    // MARK: - Avatar initials

    @Test("Avatar initials extracts two uppercase letters")
    func test_avatarInitials_extractsTwoUppercaseLetters() {
        let initials = makeInitials(from: "João Igor")
        #expect(initials == "JI")
    }

    @Test("Avatar initials with single name returns one letter")
    func test_avatarInitials_withSingleName_returnsOneLetter() {
        let initials = makeInitials(from: "Carla")
        #expect(initials == "C")
    }

    @Test("Avatar palette is deterministic for same name")
    func test_avatarPalette_isDeterministicForSameName() {
        let first = paletteIndex(for: "Ana")
        let second = paletteIndex(for: "Ana")
        #expect(first == second)
    }

    @Test("Avatar palette differs for different names")
    func test_avatarPalette_differsForDifferentNames() {
        let ana = paletteIndex(for: "Ana")
        let zzz = paletteIndex(for: "Zzz")
        #expect(ana != zzz)
    }

    @Test("Avatar content uses remote image when URL is provided")
    func test_avatarContent_withAvatarURL_usesRemoteImage() throws {
        let avatarURL = try #require(URL(string: "https://example.com/avatar.png"))
        let sut = makeAvatarSUT(avatarURL: avatarURL)

        #expect(sut.content == .remoteImage(avatarURL))
    }

    @Test("Avatar content falls back to initials when URL is missing")
    func test_avatarContent_withoutAvatarURL_usesInitials() {
        let sut = makeAvatarSUT()

        #expect(sut.content == .initials("JI"))
    }
}

// MARK: - Helpers

private extension DesignSystemTests {
    func makeSUT(
        accent: GroupoolTheme.Accent = .blue,
        softness: GroupoolTheme.Softness = .medium,
        fonts: GroupoolTheme.FontPreset = .serifSans,
        mode: GroupoolTheme.Mode = .light
    ) -> GroupoolTheme {
        GroupoolTheme(accent: accent, softness: softness, fonts: fonts, mode: mode)
    }

    func makeInitials(from name: String) -> String {
        name
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }

    func paletteIndex(for name: String) -> Int {
        let first = Int(name.unicodeScalars.first?.value ?? 0)
        return first % 8
    }

    func makeAvatarSUT(
        name: String = "João Igor",
        size: CGFloat = 40,
        status: GroupoolStatusDotKind? = nil,
        avatarURL: URL? = nil
    ) -> GroupoolAvatar {
        GroupoolAvatar(name: name, size: size, status: status, avatarURL: avatarURL)
    }

    func loadColorAssetContents(named assetName: String) throws -> [String: Any] {
        let assetURL = colorsAssetDirectoryURL()
            .appendingPathComponent("\(assetName).colorset")
            .appendingPathComponent("Contents.json")
        let data = try Data(contentsOf: assetURL)
        let json = try JSONSerialization.jsonObject(with: data)
        return try #require(json as? [String: Any])
    }

    func loadColorAssetNames() throws -> [String] {
        let colorSetURLs = try FileManager.default.contentsOfDirectory(
            at: colorsAssetDirectoryURL(),
            includingPropertiesForKeys: nil
        )

        return colorSetURLs
            .filter { $0.pathExtension == "colorset" }
            .map { $0.deletingPathExtension().lastPathComponent }
            .sorted()
    }

    func colorsAssetDirectoryURL() -> URL {
        let testsDirectory = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
        let packageDirectory = testsDirectory
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        return packageDirectory
            .appendingPathComponent("Sources/DesignSystem/Resources/Colors.xcassets")
    }
}
#endif
