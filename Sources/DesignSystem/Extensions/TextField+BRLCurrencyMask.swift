import SwiftUI

public struct DSBRLCurrencyMaskModifier: ViewModifier {
    @Binding public var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public func body(content: Content) -> some View {
        content.onChange(of: text) { oldValue, newValue in
            let oldDigits = oldValue.filter(\.isNumber)
            let newDigits = newValue.filter(\.isNumber)

            let normalizedDigits: String
            if newValue.count < oldValue.count && newDigits.count == oldDigits.count {
                normalizedDigits = String(newDigits.dropLast())
            } else {
                normalizedDigits = newDigits
            }

            text = Self.formattedCurrency(from: normalizedDigits)
        }
    }

    private static func formattedCurrency(from input: String) -> String {
        let digits = input.filter(\.isNumber)
        guard !digits.isEmpty else {
            return ""
        }

        let limited = String(digits.prefix(15))
        let cents = Int(limited) ?? 0
        return Self.currencyFormatter.string(from: NSNumber(value: Double(cents) / 100.0)) ?? "R$ 0,00"
    }

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.currencySymbol = "R$"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
}

public extension View {
    func dsBRLCurrencyMask(_ text: Binding<String>) -> some View {
        modifier(DSBRLCurrencyMaskModifier(text: text))
    }
}
