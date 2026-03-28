import SwiftUI
import UIKit

public enum DSAvatarSize {
    case small
    case medium
    case large
    case custom(CGFloat)

    public var value: CGFloat {
        switch self {
        case .small: return 44
        case .medium: return 72
        case .large: return 112
        case .custom(let size): return size
        }
    }

    var font: Font {
        switch self {
        case .small: return .dsCaption
        case .medium: return .dsCallout
        case .large: return .dsTitle
        case .custom(let size):
            if size <= 50 { return .dsCaption }
            if size <= 80 { return .dsCallout }
            return .dsTitle
        }
    }
}

public struct DSAvatar: View {
    public let avatarURL: URL?
    public let previewImage: UIImage?
    public let initials: String
    public let size: DSAvatarSize
    public let isLoading: Bool

    public init(
        avatarURL: URL? = nil,
        previewImage: UIImage? = nil,
        initials: String,
        size: DSAvatarSize,
        isLoading: Bool = false
    ) {
        self.avatarURL = avatarURL
        self.previewImage = previewImage
        self.initials = initials
        self.size = size
        self.isLoading = isLoading
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(Color.brandPrimary.opacity(0.15))
            avatarContent
            if isLoading {
                Circle()
                    .fill(Color.backgroundGrey.opacity(0.8))
                ProgressView()
            }
        }
        .frame(width: size.value, height: size.value)
        .clipShape(Circle())
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let previewImage {
            Image(uiImage: previewImage)
                .resizable()
                .scaledToFill()
        } else if let avatarURL {
            AsyncImage(url: avatarURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    initialsView
                @unknown default:
                    initialsView
                }
            }
        } else {
            initialsView
        }
    }

    private var initialsView: some View {
        Text(initials)
            .font(size.font)
            .fontWeight(.bold)
            .foregroundColor(.brandPrimary)
    }
}
