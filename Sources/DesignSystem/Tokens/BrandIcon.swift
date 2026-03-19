import SwiftUI

public enum BrandIcon: String {
    case plus = "plus"
    case checkmark = "checkmark.circle.fill"
    case error = "exclamationmark.triangle.fill"
    case warning = "exclamationmark.circle.fill"
    case info = "info.circle.fill"
    case chevronRight = "chevron.right"
    case close = "xmark"
    case challenge = "flag.checkered"
    case expense = "receipt"
    case withdrawal = "arrow.down.circle"
    
    public func view(scale: Image.Scale = .medium) -> some View {
        Image(systemName: self.rawValue)
            .symbolRenderingMode(.hierarchical)
            .imageScale(scale)
    }
}
