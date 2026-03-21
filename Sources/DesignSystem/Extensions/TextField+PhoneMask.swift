import SwiftUI

public struct DSPhoneMaskModifier: ViewModifier {
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

            text = Self.formattedPhone(from: normalizedDigits)
        }
    }

    private static func formattedPhone(from input: String) -> String {
        let digits = input.filter(\.isNumber)
        let limited = String(digits.prefix(11))
        let areaCode = limited.prefix(2)
        let prefix = limited.dropFirst(2).prefix(5)
        let suffix = limited.dropFirst(7).prefix(4)

        var result = ""

        if !areaCode.isEmpty {
            result += "(\(areaCode)"
            if areaCode.count == 2 {
                result += ") "
            }
        }

        if !prefix.isEmpty {
            result += prefix
        }

        if !suffix.isEmpty {
            result += "-\(suffix)"
        }

        return result
    }
}

public extension View {
    func dsPhoneMask(_ text: Binding<String>) -> some View {
        modifier(DSPhoneMaskModifier(text: text))
    }
}
