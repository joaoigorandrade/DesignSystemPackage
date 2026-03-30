import XCTest
@testable import DesignSystem

final class DSHapticPatternTests: XCTestCase {
    func testSegmentClampsValuesToSupportedRange() {
        let segment = DSHapticPattern.Segment(
            intensity: 2.0,
            sharpness: -1.0,
            duration: -3.0,
            relativeTime: -2.0
        )

        XCTAssertEqual(segment.intensity, 1.0)
        XCTAssertEqual(segment.sharpness, 0.0)
        XCTAssertEqual(segment.duration, 0.0)
        XCTAssertEqual(segment.relativeTime, 0.0)
    }

    func testCurveControlPointClampsValuesToSupportedRange() {
        let point = DSHapticPattern.CurveControlPoint(
            relativeTime: -1.0,
            intensity: -0.2,
            sharpness: 1.4
        )

        XCTAssertEqual(point.relativeTime, 0.0)
        XCTAssertEqual(point.intensity, 0.0)
        XCTAssertEqual(point.sharpness, 1.0)
    }
}
