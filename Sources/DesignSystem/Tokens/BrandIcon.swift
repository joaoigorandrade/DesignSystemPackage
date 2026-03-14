import SwiftUI

public enum BrandIcon: String {
    case checkmark = "checkmark.circle.fill"
    case error = "exclamationmark.triangle.fill"
    case warning = "exclamationmark.circle.fill"
    case info = "info.circle.fill"
    case chevronRight = "chevron.right"
    case close = "xmark"
    
    public func view(scale: Image.Scale = .medium) -> some View {
        Image(systemName: self.rawValue)
            .symbolRenderingMode(.hierarchical)
            .imageScale(scale)
    }
}
