import Foundation
import CoreHaptics

@MainActor
public final class DSHaptics {
    public static let shared = DSHaptics()

    private var engine: CHHapticEngine?
    private var configuration: DSHapticConfiguration
    private let supportsHaptics: Bool

    public init(configuration: DSHapticConfiguration = .default) {
        self.configuration = configuration
        supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        prepareEngineIfNeeded()
    }

    public func configure(_ configuration: DSHapticConfiguration) {
        self.configuration = configuration
    }

    public func play(event: DSHapticEvent) {
        let pattern = configuration.pattern(for: event)
        play(pattern: pattern)
    }

    public func play(pattern: DSHapticPattern) {
        guard supportsHaptics else { return }
        guard !pattern.segments.isEmpty else { return }
        prepareEngineIfNeeded()
        guard let engine else { return }

        do {
            let hapticPattern = try makeCoreHapticPattern(from: pattern)
            let player = try engine.makePlayer(with: hapticPattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            try? engine.start()
        }
    }

    private func prepareEngineIfNeeded() {
        guard supportsHaptics else { return }
        if engine != nil { return }

        do {
            let newEngine = try CHHapticEngine()
            newEngine.isAutoShutdownEnabled = true
            newEngine.resetHandler = { [weak self] in
                Task { @MainActor in
                    self?.restartEngine()
                }
            }
            newEngine.stoppedHandler = { [weak self] _ in
                Task { @MainActor in
                    self?.restartEngine()
                }
            }
            try newEngine.start()
            engine = newEngine
        } catch {
            engine = nil
        }
    }

    private func restartEngine() {
        guard supportsHaptics else { return }
        guard let engine else {
            prepareEngineIfNeeded()
            return
        }

        do {
            try engine.start()
        } catch {
            self.engine = nil
            prepareEngineIfNeeded()
        }
    }

    private func makeCoreHapticPattern(from pattern: DSHapticPattern) throws -> CHHapticPattern {
        let events = pattern.segments.map { segment in
            let parameters: [CHHapticEventParameter] = [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(segment.intensity)),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(segment.sharpness))
            ]

            if segment.duration > 0 {
                return CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: parameters,
                    relativeTime: segment.relativeTime,
                    duration: segment.duration
                )
            }

            return CHHapticEvent(
                eventType: .hapticTransient,
                parameters: parameters,
                relativeTime: segment.relativeTime
            )
        }

        let intensityCurve = makeParameterCurve(
            for: .hapticIntensityControl,
            points: pattern.curve.map { (time: $0.relativeTime, value: $0.intensity) }
        )
        let sharpnessCurve = makeParameterCurve(
            for: .hapticSharpnessControl,
            points: pattern.curve.map { (time: $0.relativeTime, value: $0.sharpness) }
        )

        var curves: [CHHapticParameterCurve] = []
        if let intensityCurve {
            curves.append(intensityCurve)
        }
        if let sharpnessCurve {
            curves.append(sharpnessCurve)
        }

        return try CHHapticPattern(events: events, parameterCurves: curves)
    }

    private func makeParameterCurve(
        for parameterID: CHHapticDynamicParameter.ID,
        points: [(time: TimeInterval, value: Double)]
    ) -> CHHapticParameterCurve? {
        guard !points.isEmpty else { return nil }

        let controlPoints = points.map {
            CHHapticParameterCurve.ControlPoint(
                relativeTime: $0.time,
                value: Float(min(max($0.value, 0), 1))
            )
        }

        return CHHapticParameterCurve(
            parameterID: parameterID,
            controlPoints: controlPoints,
            relativeTime: 0
        )
    }
}
