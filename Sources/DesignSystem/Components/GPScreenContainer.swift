import SwiftUI

public enum GPScreenHeaderStyle: Sendable {
    case plain
    case gradientWash

    public var usesGradientWash: Bool {
        switch self {
        case .plain:
            false
        case .gradientWash:
            true
        }
    }
}

public enum GPScreenMetrics {
    public static let horizontalPadding: CGFloat = 20
    public static let topPadding: CGFloat = 24
    public static let contentSpacing: CGFloat = 16
    public static let bottomBarPadding: CGFloat = 16
    public static let contentBottomPadding: CGFloat = 24
}

public struct GPScreenContainer<Header: View, Content: View, BottomBar: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let headerStyle: GPScreenHeaderStyle
    private let showsScrollIndicators: Bool
    private let header: Header
    private let content: Content
    private let bottomBar: BottomBar

    public init(
        headerStyle: GPScreenHeaderStyle = .plain,
        showsScrollIndicators: Bool = false,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomBar: () -> BottomBar
    ) {
        self.headerStyle = headerStyle
        self.showsScrollIndicators = showsScrollIndicators
        self.header = header()
        self.content = content()
        self.bottomBar = bottomBar()
    }

    public var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: showsScrollIndicators) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                        .padding(.horizontal, GPScreenMetrics.horizontalPadding)
                        .padding(.top, GPScreenMetrics.topPadding)
                        .padding(.bottom, GPScreenMetrics.contentSpacing)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(headerBackground)

                    content
                        .padding(.horizontal, GPScreenMetrics.horizontalPadding)
                        .padding(.bottom, GPScreenMetrics.contentBottomPadding)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scrollIndicators(showsScrollIndicators ? .visible : .hidden)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
        }
    }

    @ViewBuilder
    private var headerBackground: some View {
        if headerStyle.usesGradientWash {
            LinearGradient(
                colors: [theme.poolSoft, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            theme.background
        }
    }
}

public extension GPScreenContainer where BottomBar == EmptyView {
    init(
        headerStyle: GPScreenHeaderStyle = .plain,
        showsScrollIndicators: Bool = false,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            headerStyle: headerStyle,
            showsScrollIndicators: showsScrollIndicators,
            header: header,
            content: content,
            bottomBar: { EmptyView() }
        )
    }
}

public extension GPScreenContainer where Header == EmptyView {
    init(
        showsScrollIndicators: Bool = false,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomBar: () -> BottomBar
    ) {
        self.init(
            headerStyle: .plain,
            showsScrollIndicators: showsScrollIndicators,
            header: { EmptyView() },
            content: content,
            bottomBar: bottomBar
        )
    }
}

public struct GPBottomBar<Content: View>: View {
    @Environment(\.groupoolTheme) private var theme

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(theme.line)
                .frame(height: 1)

            content
                .padding(.horizontal, GPScreenMetrics.horizontalPadding)
                .padding(.vertical, GPScreenMetrics.bottomBarPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(theme.background.opacity(0.96))
        .background(.ultraThinMaterial)
    }
}

#Preview("Screen Container") {
    GPScreenContainer(headerStyle: .gradientWash) {
        VStack(alignment: .leading, spacing: 8) {
            GPTopBarView(onBack: {})
            Text("Join Groupool")
                .gpDisplay(size: 32)
            Text("Shared pools for groups who trust each other.")
                .gpUI(size: 15, color: .secondary)
        }
    } content: {
        VStack(alignment: .leading, spacing: 16) {
            GPCard {
                VStack(alignment: .leading, spacing: 12) {
                    GPSectionHeader("Preview")
                    Text("Use this shell for paper backgrounds, gradient headers, and fixed bottom actions.")
                        .gpUI(size: 15, color: .secondary)
                }
            }
        }
    } bottomBar: {
        GPBottomBar {
            Button("Continue") {}
                .buttonStyle(.gp(.primary, fullWidth: true))
        }
    }
}
