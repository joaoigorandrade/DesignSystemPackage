import Foundation

public struct DSHapticPattern: Equatable, Sendable {
    public struct Segment: Equatable, Sendable {
        public let intensity: Double
        public let sharpness: Double
        public let duration: TimeInterval
        public let relativeTime: TimeInterval

        public init(
            intensity: Double,
            sharpness: Double,
            duration: TimeInterval = 0,
            relativeTime: TimeInterval = 0
        ) {
            self.intensity = min(max(intensity, 0), 1)
            self.sharpness = min(max(sharpness, 0), 1)
            self.duration = max(duration, 0)
            self.relativeTime = max(relativeTime, 0)
        }
    }

    public struct CurveControlPoint: Equatable, Sendable {
        public let relativeTime: TimeInterval
        public let intensity: Double
        public let sharpness: Double

        public init(relativeTime: TimeInterval, intensity: Double, sharpness: Double) {
            self.relativeTime = max(relativeTime, 0)
            self.intensity = min(max(intensity, 0), 1)
            self.sharpness = min(max(sharpness, 0), 1)
        }
    }

    public let segments: [Segment]
    public let curve: [CurveControlPoint]

    public init(segments: [Segment], curve: [CurveControlPoint] = []) {
        self.segments = segments
        self.curve = curve.sorted { $0.relativeTime < $1.relativeTime }
    }

    public static func transient(
        intensity: Double,
        sharpness: Double,
        relativeTime: TimeInterval = 0
    ) -> DSHapticPattern {
        DSHapticPattern(
            segments: [
                Segment(
                    intensity: intensity,
                    sharpness: sharpness,
                    duration: 0,
                    relativeTime: relativeTime
                )
            ]
        )
    }

    public static func pulse(
        intensity: Double,
        sharpness: Double,
        duration: TimeInterval,
        relativeTime: TimeInterval = 0
    ) -> DSHapticPattern {
        DSHapticPattern(
            segments: [
                Segment(
                    intensity: intensity,
                    sharpness: sharpness,
                    duration: duration,
                    relativeTime: relativeTime
                )
            ]
        )
    }
}
