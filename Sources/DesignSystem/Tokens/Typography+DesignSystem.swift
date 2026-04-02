import SwiftUI

public extension Font {
    static let dsLargeTitle = Font.system(.largeTitle, design: .default)
    static let dsTitle = Font.system(.title, design: .default)
    static let dsHeadline = Font.system(.headline, design: .default)
    static let dsBody = Font.system(.body, design: .default)
    static let dsCallout = Font.system(.callout, design: .default)
    static let dsFootnote = Font.system(.footnote, design: .default)
    static let dsCaption = Font.system(.caption, design: .default)
}

public struct DSTypographyModifier: ViewModifier {
    public let font: Font
    public let weight: Font.Weight
    
    public init(font: Font, weight: Font.Weight) {
        self.font = font
        self.weight = weight
    }

    public func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(weight)
    }
}

public extension View {
    func dsLargeTitle() -> some View {
        self.modifier(DSTypographyModifier(font: .dsLargeTitle, weight: .bold))
    }

    func dsTitle() -> some View {
        self.modifier(DSTypographyModifier(font: .dsTitle, weight: .bold))
    }

    func dsHeadline() -> some View {
        self.modifier(DSTypographyModifier(font: .dsHeadline, weight: .semibold))
    }
    
    func dsBody() -> some View {
        self.modifier(DSTypographyModifier(font: .dsBody, weight: .regular))
    }

    func dsCallout() -> some View {
        self.modifier(DSTypographyModifier(font: .dsCallout, weight: .regular))
    }

    func dsFootnote() -> some View {
        self.modifier(DSTypographyModifier(font: .dsFootnote, weight: .regular))
    }

    func dsCaption() -> some View {
        self.modifier(DSTypographyModifier(font: .dsCaption, weight: .regular))
    }
}
