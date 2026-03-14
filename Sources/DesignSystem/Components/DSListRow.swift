import SwiftUI

public struct DSListRow<Content: View>: View {
    public let title: String
    public let subtitle: String?
    public let icon: BrandIcon?
    public let trailingContent: Content?
    
    public init(title: String, subtitle: String? = nil, icon: BrandIcon? = nil, @ViewBuilder trailingContent: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.trailingContent = trailingContent()
    }
    
    public init(title: String, subtitle: String? = nil, icon: BrandIcon? = nil) where Content == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.trailingContent = nil
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            if let icon = icon {
                icon.view(scale: .large)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 32, height: 32)
                    .background(Color.brandPrimary.opacity(0.15))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .dsHeadline()
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .dsBody()
                        .foregroundColor(.coolGrey)
                }
            }
            
            Spacer()
            
            if let trailingContent = trailingContent {
                trailingContent
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .glassEffect(cornerRadius: 20)
    }
}
