import SwiftUI

public struct GPVoteOptionView: View {
    @Environment(\.groupoolTheme) private var theme

    private let letter: String
    private let title: String
    private let votes: Int
    private let totalVotes: Int
    private let isPicked: Bool
    private let action: () -> Void

    public init(letter: String, title: String, votes: Int, totalVotes: Int, isPicked: Bool, action: @escaping () -> Void) {
        self.letter = letter
        self.title = title
        self.votes = votes
        self.totalVotes = totalVotes
        self.isPicked = isPicked
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(isPicked ? theme.pool : theme.lineSecondary)
                    .frame(width: 36, height: 36)
                    .overlay {
                        Text(letter)
                            .groupoolTextStyle(.title, color: isPicked ? .white : theme.inkTertiary)
                    }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(title)
                            .groupoolTextStyle(.bodyStrong)
                        Spacer()
                        Text("\(votes) voto\(votes == 1 ? "" : "s")")
                            .groupoolTextStyle(.caption, color: theme.inkTertiary)
                    }

                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(theme.line)
                                .frame(height: 4)
                            Capsule()
                                .fill(isPicked ? theme.pool : theme.inkSecondary)
                                .frame(width: totalVotes > 0 ? proxy.size.width * CGFloat(votes) / CGFloat(totalVotes) : 0, height: 4)
                        }
                    }
                    .frame(height: 4)
                }

                ZStack {
                    Circle()
                        .stroke(isPicked ? theme.pool : theme.lineSecondary, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isPicked {
                        Circle()
                            .fill(theme.pool)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(14)
            .background(isPicked ? theme.poolSoft : theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: GPRadii.medium, style: .continuous)
                    .stroke(isPicked ? theme.pool : theme.line, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: GPRadii.medium, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Vote Options") {
    @Previewable @State var picked: String? = nil
    VStack(spacing: 8) {
        GPVoteOptionView(letter: "A", title: "João Igor vence", votes: 3, totalVotes: 5, isPicked: picked == "A") { picked = "A" }
        GPVoteOptionView(letter: "B", title: "Ana Silva vence", votes: 2, totalVotes: 5, isPicked: picked == "B") { picked = "B" }
        GPVoteOptionView(letter: "C", title: "Empate técnico", votes: 0, totalVotes: 5, isPicked: picked == "C") { picked = "C" }
    }
    .padding()
}
