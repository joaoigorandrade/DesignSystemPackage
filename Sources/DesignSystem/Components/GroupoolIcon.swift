import SwiftUI

public struct GroupoolIcon: View {
    private let name: String
    private let size: CGFloat
    private let color: Color

    public init(_ name: String, size: CGFloat = 20, color: Color = .primary) {
        self.name = name
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
    }
}
