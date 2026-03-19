import SwiftUI

public enum ProfileSummaryAction: String, Identifiable, CaseIterable, Sendable {
    case editProfile
    case pixKeys
    case appSettings
    case logOut

    public var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .editProfile:
            return "Edit Profile"
        case .pixKeys:
            return "PIX Keys"
        case .appSettings:
            return "App Settings"
        case .logOut:
            return "Log Out"
        }
    }
}

public struct ProfileSummaryCard: View {
    public let displayName: String
    public let statusText: String
    public let avatarURL: URL?
    public let initials: String
    public let challengesWonText: String
    public let challengesLostText: String
    public let reliabilityText: String
    public let reputationText: String
    public let onAvatarTap: () -> Void
    public let onActionTap: (ProfileSummaryAction) -> Void

    public init(
        displayName: String,
        statusText: String,
        avatarURL: URL?,
        initials: String,
        challengesWonText: String,
        challengesLostText: String,
        reliabilityText: String,
        reputationText: String,
        onAvatarTap: @escaping () -> Void,
        onActionTap: @escaping (ProfileSummaryAction) -> Void
    ) {
        self.displayName = displayName
        self.statusText = statusText
        self.avatarURL = avatarURL
        self.initials = initials
        self.challengesWonText = challengesWonText
        self.challengesLostText = challengesLostText
        self.reliabilityText = reliabilityText
        self.reputationText = reputationText
        self.onAvatarTap = onAvatarTap
        self.onActionTap = onActionTap
    }

    public var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: 16) {
                header
                stats
                reputation
                actionLinks
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button(action: onAvatarTap) {
                AvatarImage(avatarURL: avatarURL, initials: initials)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(.dsTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                    .lineLimit(1)
                StatusBadge(text: statusText)
            }
        }
    }

    private var stats: some View {
        HStack(spacing: 8) {
            StatItem(title: "Challenges Won", value: challengesWonText)
            StatSeparator()
            StatItem(title: "Lost", value: challengesLostText)
            StatSeparator()
            StatItem(title: "Reliability", value: reliabilityText)
        }
    }

    private var reputation: some View {
        Text(reputationText)
            .font(.dsCallout)
            .fontWeight(.semibold)
            .foregroundColor(.brandPrimary)
    }

    private var actionLinks: some View {
        VStack(spacing: 2) {
            ForEach(ProfileSummaryAction.allCases, id: \.id) { action in
                ActionRow(action: action, onTap: onActionTap)
            }
        }
    }
}

private struct AvatarImage: View {
    let avatarURL: URL?
    let initials: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimary.opacity(0.15))
            if let avatarURL {
                AsyncImage(url: avatarURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(Circle())
    }

    private var initialsView: some View {
        Text(initials)
            .font(.dsCallout)
            .fontWeight(.bold)
            .foregroundColor(.brandPrimary)
    }
}

private struct StatusBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.dsFootnote)
            .fontWeight(.bold)
            .foregroundColor(.brandPrimary)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.success.opacity(0.24))
            .clipShape(Capsule())
    }
}

private struct StatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.dsCaption)
                .foregroundColor(.coolGrey)
            Text(value)
                .font(.dsCallout)
                .fontWeight(.semibold)
                .foregroundColor(.brandPrimary)
        }
    }
}

private struct StatSeparator: View {
    var body: some View {
        Circle()
            .fill(Color.coolGrey.opacity(0.5))
            .frame(width: 4, height: 4)
    }
}

private struct ActionRow: View {
    let action: ProfileSummaryAction
    let onTap: (ProfileSummaryAction) -> Void

    var body: some View {
        Button {
            onTap(action)
        } label: {
            HStack {
                Text(action.title)
                    .font(.dsBody)
                    .foregroundColor(.brandPrimary)
                Spacer()
                BrandIcon.chevronRight
                    .view()
                    .foregroundColor(.coolGrey)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}
