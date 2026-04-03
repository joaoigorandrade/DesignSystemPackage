import SwiftUI
import Combine

public struct DSVerticalCarousel<Item: Identifiable, Content: View>: View where Item.ID: Hashable {
    private let items: [Item]
    private let autoAdvanceInterval: TimeInterval
    private let resumeDelay: TimeInterval
    private let height: CGFloat
    private let content: (Item) -> Content
    private let minimumAutoAdvanceInterval: TimeInterval = 0.1

    @State private var currentPageIndex = 0
    @State private var resumeAt: Date?
    @State private var availableWidth: CGFloat = 0
    @State private var measuredItemWidths: [AnyHashable: CGFloat] = [:]

    public init(
        items: [Item],
        itemWidth: CGFloat? = nil,
        autoAdvanceInterval: TimeInterval = 4,
        resumeDelay: TimeInterval = 5,
        height: CGFloat = 80,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.autoAdvanceInterval = autoAdvanceInterval
        self.resumeDelay = resumeDelay
        self.height = height
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                DSVerticalCarouselPage(items: currentPage, content: content)
                    .id(currentPageIndex)
                    .transition(pageTransition)
                DSVerticalCarouselMeasurementLayer(items: items, content: content)
                    .allowsHitTesting(false)
                    .opacity(0)
            }
            .onAppear { availableWidth = geometry.size.width }
            .onChange(of: geometry.size.width) { _, newWidth in availableWidth = newWidth }
            .onPreferenceChange(DSVerticalCarouselWidthPreferenceKey.self) { preferences in
                measuredItemWidths = preferences
            }
        }
        .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
        .clipped()
        .simultaneousGesture(interactionGesture)
        .onReceive(timer) { _ in
            guard canAutoAdvance else { return }
            advance()
        }
        .onChange(of: items.count) { _, _ in
            if currentPageIndex >= pages.count { currentPageIndex = 0 }
        }
    }

    private func effectiveItemWidth(for item: Item) -> CGFloat {
        measuredItemWidths[AnyHashable(item.id)] ?? height
    }

    private var pages: [[Item]] {
        guard !items.isEmpty else { return [] }
        guard availableWidth > 0 else { return items.map { [$0] } }

        var result: [[Item]] = []
        var currentPage: [Item] = []
        var currentWidth: CGFloat = 0

        for item in items {
            let width = effectiveItemWidth(for: item)
            let spacing = currentPage.isEmpty ? 0 : DSSpacing.space12
            let proposedWidth = currentWidth + spacing + width

            if !currentPage.isEmpty && proposedWidth > availableWidth {
                result.append(currentPage)
                currentPage = [item]
                currentWidth = width
            } else {
                currentPage.append(item)
                currentWidth = proposedWidth
            }
        }

        if !currentPage.isEmpty {
            result.append(currentPage)
        }

        return result
    }

    private var currentPage: [Item] {
        guard !pages.isEmpty else { return [] }
        return pages[currentPageIndex % pages.count]
    }

    private var pageTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    private var interactionGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in pauseAutoAdvance() }
            .onEnded { _ in pauseAutoAdvance() }
    }

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(
            every: max(minimumAutoAdvanceInterval, autoAdvanceInterval),
            on: .main,
            in: .common
        ).autoconnect()
    }

    private var canAutoAdvance: Bool {
        guard pages.count > 1 else { return false }
        guard let resumeAt else { return true }
        return Date() >= resumeAt
    }

    private func pauseAutoAdvance() {
        resumeAt = Date().addingTimeInterval(resumeDelay)
    }

    private func advance() {
        let next = (currentPageIndex + 1) % pages.count
        withAnimation(.easeInOut(duration: 0.35)) {
            currentPageIndex = next
        }
    }
}

private struct DSVerticalCarouselMeasurementLayer<Item: Identifiable, Content: View>: View where Item.ID: Hashable {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        HStack(spacing: DSSpacing.space12) {
            ForEach(items) { item in
                content(item)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: DSVerticalCarouselWidthPreferenceKey.self,
                                value: [AnyHashable(item.id): geometry.size.width]
                            )
                        }
                    )
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

private struct DSVerticalCarouselPage<Item: Identifiable, Content: View>: View where Item.ID: Hashable {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        HStack(spacing: DSSpacing.space12) {
            ForEach(items) { item in
                content(item)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DSVerticalCarouselWidthPreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [AnyHashable: CGFloat] = [:]

    static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}
