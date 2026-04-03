import SwiftUI
import Combine

public struct DSAutoCarousel<Item: Identifiable, Content: View>: View where Item.ID: Hashable {
    private let items: [Item]
    private let autoAdvanceInterval: TimeInterval
    private let resumeDelay: TimeInterval
    private let content: (Item) -> Content
    private let minimumAutoAdvanceInterval: TimeInterval = 0.1

    @State private var selectedIndex = 0
    @State private var resumeAt: Date?

    public init(
        items: [Item],
        autoAdvanceInterval: TimeInterval = 4,
        resumeDelay: TimeInterval = 5,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.autoAdvanceInterval = autoAdvanceInterval
        self.resumeDelay = resumeDelay
        self.content = content
    }

    public var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                content(item)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
        .simultaneousGesture(interactionGesture)
        .onReceive(timer) { _ in
            guard canAutoAdvance else { return }
            advance()
        }
        .onChange(of: items.count) { _, count in
            guard count > 0 else {
                selectedIndex = 0
                return
            }

            if selectedIndex >= count {
                selectedIndex = 0
            }
        }
    }

    private var interactionGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                pauseAutoAdvance()
            }
            .onEnded { _ in
                pauseAutoAdvance()
            }
    }

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: max(minimumAutoAdvanceInterval, autoAdvanceInterval), on: .main, in: .common)
            .autoconnect()
    }

    private var canAutoAdvance: Bool {
        guard items.count > 1 else { return false }
        guard let resumeAt else { return true }
        return Date() >= resumeAt
    }

    private func pauseAutoAdvance() {
        resumeAt = Date().addingTimeInterval(resumeDelay)
    }

    private func advance() {
        let next = (selectedIndex + 1) % items.count
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedIndex = next
        }
    }
}
