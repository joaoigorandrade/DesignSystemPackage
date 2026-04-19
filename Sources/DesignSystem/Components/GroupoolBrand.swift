import SwiftUI

public struct GroupoolMark: View {
    @Environment(\.groupoolTheme) private var theme

    private let size: CGFloat

    public init(size: CGFloat = 28) {
        self.size = size
    }

    public var body: some View {
        Canvas { context, canvasSize in
            let rect = CGRect(origin: .zero, size: canvasSize)
            let bodyRect = rect.insetBy(dx: rect.width * 0.1, dy: rect.height * 0.2)
            context.fill(Path(ellipseIn: bodyRect), with: .color(theme.wood))
            let waterRect = CGRect(
                x: rect.width * 0.2,
                y: rect.height * 0.34,
                width: rect.width * 0.6,
                height: rect.height * 0.34
            )
            context.fill(Path(ellipseIn: waterRect), with: .color(theme.pool))
            context.fill(Path(ellipseIn: CGRect(x: rect.width * 0.35, y: rect.height * 0.45, width: rect.width * 0.08, height: rect.height * 0.08)), with: .color(theme.ink))
            context.fill(Path(ellipseIn: CGRect(x: rect.width * 0.57, y: rect.height * 0.45, width: rect.width * 0.08, height: rect.height * 0.08)), with: .color(theme.ink))
            var mouth = Path()
            mouth.move(to: CGPoint(x: rect.width * 0.42, y: rect.height * 0.63))
            mouth.addQuadCurve(
                to: CGPoint(x: rect.width * 0.58, y: rect.height * 0.63),
                control: CGPoint(x: rect.width * 0.5, y: rect.height * 0.72)
            )
            context.stroke(mouth, with: .color(theme.ink), lineWidth: 1.2)
        }
        .frame(width: size, height: size)
    }
}

public enum GroupoolMascotExpression: Sendable {
    case happy
    case surprised
    case sleepy
    case wink
    case sparkle
}

public struct GroupoolMascot: View {
    @Environment(\.groupoolTheme) private var theme

    private let size: CGFloat
    private let expression: GroupoolMascotExpression
    private let showLadder: Bool

    public init(size: CGFloat = 120, expression: GroupoolMascotExpression = .happy, showLadder: Bool = true) {
        self.size = size
        self.expression = expression
        self.showLadder = showLadder
    }

    public var body: some View {
        Canvas { context, canvasSize in
            let width = canvasSize.width
            let height = canvasSize.height
            let tubRect = CGRect(x: width * 0.09, y: height * 0.42, width: width * 0.82, height: height * 0.42)
            let rimRect = CGRect(x: width * 0.07, y: height * 0.24, width: width * 0.86, height: height * 0.22)
            let waterRect = CGRect(x: width * 0.13, y: height * 0.26, width: width * 0.74, height: height * 0.16)
            context.fill(Path(ellipseIn: CGRect(x: width * 0.09, y: height * 0.66, width: width * 0.82, height: height * 0.15)), with: .color(theme.woodDark))
            context.fill(Path(roundedRect: tubRect, cornerRadius: tubRect.height / 2), with: .linearGradient(Gradient(colors: [theme.wood, theme.woodDark]), startPoint: CGPoint(x: width * 0.5, y: tubRect.minY), endPoint: CGPoint(x: width * 0.5, y: tubRect.maxY)))
            for x in stride(from: tubRect.minX + 18, through: tubRect.maxX - 18, by: 20) {
                var slat = Path()
                slat.move(to: CGPoint(x: x, y: tubRect.minY + 8))
                slat.addLine(to: CGPoint(x: x, y: tubRect.maxY - 10))
                context.stroke(slat, with: .color(theme.woodDark.opacity(0.5)), lineWidth: 1)
            }
            context.fill(Path(ellipseIn: rimRect), with: .color(theme.wood))
            context.stroke(Path(ellipseIn: rimRect), with: .color(theme.woodDark.opacity(0.45)), lineWidth: 1)
            context.fill(Path(ellipseIn: waterRect), with: .radialGradient(Gradient(colors: [theme.pool, theme.poolDeep]), center: CGPoint(x: width * 0.5, y: height * 0.3), startRadius: 4, endRadius: width * 0.34))
            context.fill(Path(ellipseIn: CGRect(x: width * 0.3, y: height * 0.23, width: width * 0.22, height: height * 0.03)), with: .color(.white.opacity(0.35)))
            drawExpression(in: &context, width: width, height: height)
            if showLadder {
                drawLadder(in: &context, width: width, height: height)
            }
        }
        .frame(width: size, height: size * 0.85)
    }

    private func drawExpression(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        switch expression {
        case .happy:
            drawEyeDots(in: &context, width: width, height: height, rightEye: true)
            drawSmile(in: &context, width: width, height: height)
            drawBlush(in: &context, width: width, height: height)
        case .surprised:
            drawEyeDots(in: &context, width: width, height: height, rightEye: false)
            context.fill(Path(ellipseIn: CGRect(x: width * 0.48, y: height * 0.52, width: width * 0.04, height: height * 0.035)), with: .color(theme.ink))
            drawBlush(in: &context, width: width, height: height)
        case .sleepy:
            drawSleepyEyes(in: &context, width: width, height: height)
            drawSoftSmile(in: &context, width: width, height: height)
        case .wink:
            drawWink(in: &context, width: width, height: height)
            drawSmile(in: &context, width: width, height: height)
            drawBlush(in: &context, width: width, height: height)
        case .sparkle:
            drawSparkles(in: &context, width: width, height: height)
            drawSmile(in: &context, width: width, height: height)
            drawBlush(in: &context, width: width, height: height)
        }
    }

    private func drawEyeDots(in context: inout GraphicsContext, width: CGFloat, height: CGFloat, rightEye: Bool) {
        context.fill(Path(ellipseIn: CGRect(x: width * 0.37, y: height * 0.43, width: width * 0.04, height: height * 0.04)), with: .color(theme.ink))
        if rightEye {
            context.fill(Path(ellipseIn: CGRect(x: width * 0.59, y: height * 0.43, width: width * 0.04, height: height * 0.04)), with: .color(theme.ink))
        } else {
            context.fill(Path(ellipseIn: CGRect(x: width * 0.59, y: height * 0.43, width: width * 0.04, height: height * 0.04)), with: .color(theme.ink))
        }
    }

    private func drawSmile(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        var path = Path()
        path.move(to: CGPoint(x: width * 0.46, y: height * 0.5))
        path.addQuadCurve(to: CGPoint(x: width * 0.54, y: height * 0.5), control: CGPoint(x: width * 0.5, y: height * 0.56))
        context.stroke(path, with: .color(theme.ink), lineWidth: 2)
    }

    private func drawSoftSmile(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        var path = Path()
        path.move(to: CGPoint(x: width * 0.47, y: height * 0.51))
        path.addQuadCurve(to: CGPoint(x: width * 0.53, y: height * 0.51), control: CGPoint(x: width * 0.5, y: height * 0.54))
        context.stroke(path, with: .color(theme.ink), lineWidth: 2)
    }

    private func drawSleepyEyes(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        var left = Path()
        left.move(to: CGPoint(x: width * 0.35, y: height * 0.44))
        left.addQuadCurve(to: CGPoint(x: width * 0.43, y: height * 0.44), control: CGPoint(x: width * 0.39, y: height * 0.42))
        context.stroke(left, with: .color(theme.ink), lineWidth: 2)
        var right = Path()
        right.move(to: CGPoint(x: width * 0.57, y: height * 0.44))
        right.addQuadCurve(to: CGPoint(x: width * 0.65, y: height * 0.44), control: CGPoint(x: width * 0.61, y: height * 0.42))
        context.stroke(right, with: .color(theme.ink), lineWidth: 2)
    }

    private func drawWink(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        context.fill(Path(ellipseIn: CGRect(x: width * 0.37, y: height * 0.43, width: width * 0.04, height: height * 0.04)), with: .color(theme.ink))
        var wink = Path()
        wink.move(to: CGPoint(x: width * 0.57, y: height * 0.44))
        wink.addQuadCurve(to: CGPoint(x: width * 0.65, y: height * 0.44), control: CGPoint(x: width * 0.61, y: height * 0.42))
        context.stroke(wink, with: .color(theme.ink), lineWidth: 2)
    }

    private func drawSparkles(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        drawStar(in: &context, center: CGPoint(x: width * 0.4, y: height * 0.45), size: width * 0.045)
        drawStar(in: &context, center: CGPoint(x: width * 0.6, y: height * 0.45), size: width * 0.045)
    }

    private func drawStar(in context: inout GraphicsContext, center: CGPoint, size: CGFloat) {
        var path = Path()
        path.move(to: CGPoint(x: center.x, y: center.y - size))
        path.addLine(to: CGPoint(x: center.x + size * 0.35, y: center.y))
        path.addLine(to: CGPoint(x: center.x + size, y: center.y))
        path.addLine(to: CGPoint(x: center.x + size * 0.4, y: center.y + size * 0.35))
        path.addLine(to: CGPoint(x: center.x + size * 0.65, y: center.y + size))
        path.addLine(to: CGPoint(x: center.x, y: center.y + size * 0.45))
        path.addLine(to: CGPoint(x: center.x - size * 0.65, y: center.y + size))
        path.addLine(to: CGPoint(x: center.x - size * 0.4, y: center.y + size * 0.35))
        path.addLine(to: CGPoint(x: center.x - size, y: center.y))
        path.addLine(to: CGPoint(x: center.x - size * 0.35, y: center.y))
        path.closeSubpath()
        context.fill(path, with: .color(.white))
    }

    private func drawBlush(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        context.fill(Path(ellipseIn: CGRect(x: width * 0.3, y: height * 0.47, width: width * 0.06, height: height * 0.05)), with: .color(Color(hex: "#E89A9A").opacity(0.6)))
        context.fill(Path(ellipseIn: CGRect(x: width * 0.64, y: height * 0.47, width: width * 0.06, height: height * 0.05)), with: .color(Color(hex: "#E89A9A").opacity(0.6)))
    }

    private func drawLadder(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        let ladderColor = Color(hex: "#E5E5E5")
        var railLeft = Path()
        railLeft.move(to: CGPoint(x: width * 0.74, y: height * 0.28))
        railLeft.addLine(to: CGPoint(x: width * 0.74, y: height * 0.56))
        context.stroke(railLeft, with: .color(ladderColor), lineWidth: 2.5)
        var railRight = Path()
        railRight.move(to: CGPoint(x: width * 0.82, y: height * 0.28))
        railRight.addLine(to: CGPoint(x: width * 0.82, y: height * 0.56))
        context.stroke(railRight, with: .color(ladderColor), lineWidth: 2.5)
        for rungY in [height * 0.36, height * 0.45] {
            var rung = Path()
            rung.move(to: CGPoint(x: width * 0.74, y: rungY))
            rung.addLine(to: CGPoint(x: width * 0.82, y: rungY))
            context.stroke(rung, with: .color(ladderColor), lineWidth: 2.5)
        }
    }
}
