import XCTest
@testable import DesignSystem

final class DSHapticConfigurationTests: XCTestCase {
    func testDefaultConfigurationProvidesPatternForAllEvents() {
        let configuration = DSHapticConfiguration.default

        for event in DSHapticEvent.allCases {
            XCTAssertFalse(configuration.pattern(for: event).segments.isEmpty)
        }
    }

    func testOverridesReplaceDefaultPattern() {
        let overridePattern = DSHapticPattern.pulse(
            intensity: 0.25,
            sharpness: 0.9,
            duration: 0.08
        )
        let configuration = DSHapticConfiguration(overrides: [.selection: overridePattern])

        XCTAssertEqual(configuration.pattern(for: .selection), overridePattern)
    }

    func testSetPatternUpdatesStoredPattern() {
        var configuration = DSHapticConfiguration.default
        let newPattern = DSHapticPattern.transient(intensity: 0.9, sharpness: 0.2)

        configuration.setPattern(newPattern, for: .tapPrimary)

        XCTAssertEqual(configuration.pattern(for: .tapPrimary), newPattern)
    }
}
