import Foundation

public struct DSHapticConfiguration: Equatable, Sendable {
    private var mapping: [DSHapticEvent: DSHapticPattern]

    public init(overrides: [DSHapticEvent: DSHapticPattern] = [:]) {
        mapping = Self.defaultMapping
        for (event, pattern) in overrides {
            mapping[event] = pattern
        }
    }

    public func pattern(for event: DSHapticEvent) -> DSHapticPattern {
        mapping[event] ?? Self.defaultMapping[event] ?? .transient(intensity: 0.5, sharpness: 0.5)
    }

    public mutating func setPattern(_ pattern: DSHapticPattern, for event: DSHapticEvent) {
        mapping[event] = pattern
    }

    public static let `default` = DSHapticConfiguration()
}

private extension DSHapticConfiguration {
    static let defaultMapping: [DSHapticEvent: DSHapticPattern] = [
        .tapPrimary: .transient(intensity: 0.55, sharpness: 0.45),
        .tapSecondary: .transient(intensity: 0.35, sharpness: 0.35),
        .selection: .transient(intensity: 0.35, sharpness: 0.5),
        .success: DSHapticPattern(
            segments: [
                .init(intensity: 0.5, sharpness: 0.4, relativeTime: 0),
                .init(intensity: 0.7, sharpness: 0.55, relativeTime: 0.12)
            ]
        ),
        .error: DSHapticPattern(
            segments: [
                .init(intensity: 0.85, sharpness: 0.75, relativeTime: 0),
                .init(intensity: 0.7, sharpness: 0.9, relativeTime: 0.16)
            ]
        ),
        .warning: .transient(intensity: 0.8, sharpness: 0.85)
    ]
}
