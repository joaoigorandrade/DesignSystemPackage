import SwiftUI

public struct GPQRPlaceholderView: View {
    @Environment(\.groupoolTheme) private var theme

    private let size: CGFloat

    public init(size: CGFloat = 200) {
        self.size = size
    }

    public var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cell = w / 21

            let background = Path(CGRect(origin: .zero, size: canvasSize))
            context.fill(background, with: .color(theme.surface))

            for row in 0..<21 {
                for col in 0..<21 {
                    guard isFilledCell(row: row, col: col) else { continue }
                    let rect = CGRect(x: CGFloat(col) * cell, y: CGFloat(row) * cell, width: cell, height: cell)
                    context.fill(Path(rect), with: .color(theme.ink))
                }
            }

            let finderSize: CGFloat = cell * 7
            drawFinder(context: &context, theme: theme, x: 0, y: 0, size: finderSize)
            drawFinder(context: &context, theme: theme, x: w - finderSize, y: 0, size: finderSize)
            drawFinder(context: &context, theme: theme, x: 0, y: h - finderSize, size: finderSize)
        }
        .frame(width: size, height: size)
        .padding(12)
        .background(theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: GPRadii.medium, style: .continuous)
                .stroke(theme.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: GPRadii.medium, style: .continuous))
    }

    private func drawFinder(context: inout GraphicsContext, theme: GroupoolTheme, x: CGFloat, y: CGFloat, size: CGFloat) {
        let outer = Path(CGRect(x: x, y: y, width: size, height: size))
        context.fill(outer, with: .color(theme.ink))
        let mid = Path(CGRect(x: x + size * 0.143, y: y + size * 0.143, width: size * 0.714, height: size * 0.714))
        context.fill(mid, with: .color(theme.surface))
        let inner = Path(CGRect(x: x + size * 0.286, y: y + size * 0.286, width: size * 0.428, height: size * 0.428))
        context.fill(inner, with: .color(theme.ink))
    }

    private func isFilledCell(row: Int, col: Int) -> Bool {
        let isFinderZone =
            (row < 8 && col < 8) ||
            (row < 8 && col >= 13) ||
            (row >= 13 && col < 8)
        if isFinderZone { return false }
        let seed = (row * 31 + col * 17) ^ (row + col * 7)
        return seed % 3 != 0
    }
}

#Preview("QR Placeholder") {
    GPQRPlaceholderView(size: 200)
        .padding()
}
