import SwiftUI

public struct GroupoolIcon: View {
    private let name: String
    private let size: CGFloat
    private let color: Color

    public init(_ name: String, size: CGFloat = 20, color: Color = .primary) {
        self.name = name
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: symbolName)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
    }

    private var symbolName: String {
        switch name {
        case "home": "house"
        case "activity": "waveform.path.ecg"
        case "ledger": "list.bullet.rectangle"
        case "profile": "person.crop.circle"
        case "plus": "plus"
        case "chevron-right": "chevron.right"
        case "chevron-left": "chevron.left"
        case "close": "xmark"
        case "check": "checkmark"
        case "arrow-up": "arrow.up"
        case "arrow-down": "arrow.down"
        case "arrow-right": "arrow.right"
        case "dollar": "dollarsign"
        case "swords": "flag.2.crossed"
        case "receipt": "receipt"
        case "users": "person.2"
        case "shield": "shield"
        case "clock": "clock"
        case "bell": "bell"
        case "send": "paperplane"
        case "camera": "camera"
        case "eye": "eye"
        case "settings": "gearshape"
        case "whatsapp": "message"
        case "pix": "qrcode"
        case "flag": "flag"
        case "more": "ellipsis"
        case "copy": "doc.on.doc"
        case "search": "magnifyingglass"
        default: "circle"
        }
    }
}
