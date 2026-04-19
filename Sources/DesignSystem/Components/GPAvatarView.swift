import SwiftUI

public struct GPAvatarView: View {
    private let name: String
    private let size: CGFloat
    private let status: GPMemberStatus?
    private let avatarURL: URL?

    public init(name: String, size: CGFloat = 40, status: GPMemberStatus? = nil, avatarURL: URL? = nil) {
        self.name = name
        self.size = size
        self.status = status
        self.avatarURL = avatarURL
    }

    public var body: some View {
        GroupoolAvatar(
            name: name,
            size: size,
            status: status.map(\.dotKind),
            avatarURL: avatarURL
        )
    }
}

public struct GPStatusDotView: View {
    private let status: GPMemberStatus

    public init(_ status: GPMemberStatus) {
        self.status = status
    }

    public var body: some View {
        GroupoolStatusDot(status.dotKind)
    }
}

private extension GPMemberStatus {
    var dotKind: GroupoolStatusDotKind {
        switch self {
        case .good: .good
        case .observer: .observer
        case .inactive: .inactive
        case .debt: .debt
        case .restricted: .restricted
        }
    }
}

#Preview("Avatar Variants") {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            ForEach(GPMemberStatus.allCases, id: \.self) { status in
                VStack(spacing: 4) {
                    GPAvatarView(name: "João Igor", size: 44, status: status)
                    Text(status.rawValue)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
        HStack(spacing: 12) {
            GPAvatarView(name: "Ana Silva", size: 40)
            GPAvatarView(name: "Bruno Costa", size: 40)
            GPAvatarView(name: "Carla Dias", size: 40)
            GPAvatarView(name: "Diego Ramos", size: 40)
            GPAvatarView(name: "Eva Torres", size: 40)
        }
    }
    .padding()
}
