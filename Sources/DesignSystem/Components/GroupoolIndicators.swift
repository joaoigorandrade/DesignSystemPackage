import SwiftUI

public enum GroupoolPillVariant: Sendable {
    case good
    case warning
    case bad
    case pool
    case neutral
}

public struct GroupoolPill<Leading: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let text: String
    private let variant: GroupoolPillVariant
    private let leading: Leading

    public init(_ text: String, variant: GroupoolPillVariant = .neutral, @ViewBuilder leading: () -> Leading = { EmptyView() }) {
        self.text = text
        self.variant = variant
        self.leading = leading()
    }

    public var body: some View {
        HStack(spacing: 0) {
            leading
            Text(text)
                .groupoolTextStyle(.caption, color: foregroundColor)
        }
        .padding(.horizontal, 4)
        .frame(height: 24)
        .clipShape(Capsule())
    }

    private var foregroundColor: Color {
        switch variant {
        case .good: theme.good
        case .warning: theme.warning
        case .bad: theme.bad
        case .pool: theme.poolDeep
        case .neutral: theme.inkSecondary
        }
    }
}

public enum GroupoolStatusDotKind: Sendable {
    case good
    case observer
    case inactive
    case debt
    case restricted

    var symbol: String? {
        switch self {
        case .good, .inactive: nil
        case .observer: "eye"
        case .debt, .restricted: "exclamationmark"
        }
    }
}

public struct GroupoolStatusDot: View {
    @Environment(\.groupoolTheme) private var theme

    private let kind: GroupoolStatusDotKind

    public init(_ kind: GroupoolStatusDotKind) {
        self.kind = kind
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(color)
            if let symbol = kind.symbol {
                Image(systemName: symbol)
                    .font(.system(size: 7, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 14, height: 14)
        .overlay(Circle().stroke(theme.surface, lineWidth: 2))
    }

    private var color: Color {
        switch kind {
        case .good: theme.good
        case .observer: theme.accent == .violet ? theme.pool : .groupoolPoolViolet
        case .inactive: theme.inkTertiary
        case .debt: theme.bad
        case .restricted: theme.warning
        }
    }
}

public struct GroupoolOTPCell: View {
    @Environment(\.groupoolTheme) private var theme

    private let value: String

    public init(_ value: String = "") {
        self.value = value
    }

    public var body: some View {
        Text(value)
            .groupoolTextStyle(.title)
            .frame(width: 44, height: 56)
            .background(theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                    .stroke(value.isEmpty ? theme.line : theme.pool, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous))
    }
}

public struct GroupoolWaterFill: View {
    @Environment(\.groupoolTheme) private var theme

    private let progress: Double
    private let label: String?
    private let height: CGFloat

    public init(progress: Double, label: String? = nil, height: CGFloat = 52) {
        self.progress = min(max(progress, 0), 1)
        self.label = label
        self.height = height
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: GroupoolRadius.medium(for: theme), style: .continuous)
                    .fill(theme.wood)
                RoundedRectangle(cornerRadius: max(GroupoolRadius.medium(for: theme) - 4, 0), style: .continuous)
                    .fill(theme.poolDeep)
                    .padding(4)
                    .overlay {
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            if progress > 0 {
                                ZStack(alignment: .top) {
                                    
                                    RoundedRectangle(cornerRadius: max(GroupoolRadius.medium(for: theme) - 4, 0), style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [theme.pool, theme.poolDeep],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .padding(.bottom, 4)
                                    
                                    if progress < 0.9 {
                                        GroupoolWaveShape()
                                            .fill(theme.pool)
                                            .frame(height: 8)
                                            .offset(y: -4)
                                    }
                                }
                                .frame(height: max((height - 8) * progress, 0))
                                .padding(4)
                            }
                        }
                    }
                if let label {
                    Text(label)
                        .groupoolTextStyle(.caption, color: .white)
                        .shadow(color: .black.opacity(0.18), radius: 2, y: 1)
                }
            }
        }
        .frame(height: height)
    }
}

public struct GroupoolWaveShape: Shape {
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.width / 2, y: rect.midY),
            control: CGPoint(x: rect.width / 4, y: 0)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.width * 0.75, y: rect.height)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

public struct GroupoolSegmentedControl<Option: Hashable & Sendable>: View {
    @Environment(\.groupoolTheme) private var theme

    private let options: [Option]
    @Binding private var selection: Option
    private let title: (Option) -> String

    public init(
        options: [Option],
        selection: Binding<Option>,
        title: @escaping (Option) -> String
    ) {
        self.options = options
        self._selection = selection
        self.title = title
    }

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Text(title(option))
                        .groupoolTextStyle(.caption, color: selection == option ? theme.ink : theme.inkSecondary)
                        .padding(.horizontal, 14)
                        .frame(height: 34)
                        .background(selection == option ? theme.surface : .clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(theme.line)
        .clipShape(Capsule())
    }
}
