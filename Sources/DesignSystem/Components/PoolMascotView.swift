import SwiftUI

public typealias PoolMascotView = GroupoolMascot
public typealias GPMascotExpression = GroupoolMascotExpression
public typealias GroupoolMarkView = GroupoolMark

#Preview("Mascot Expressions") {
    HStack(spacing: 24) {
        ForEach([GPMascotExpression.happy, .surprised, .sleepy, .wink, .sparkle], id: \.self) { expr in
            VStack(spacing: 4) {
                PoolMascotView(size: 80, expression: expr, showLadder: false)
                Text("\(expr)".capitalized)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
}
