import SwiftUI

public enum GPIconName: String, CaseIterable, Sendable {
    case home
    case activity
    case ledger
    case profile
    case plus
    case chevronRight
    case chevronLeft
    case close
    case check
    case arrowUp
    case arrowDown
    case arrowRight
    case dollar
    case swords
    case receipt
    case users
    case shield
    case clock
    case bell
    case send
    case camera
    case eye
    case settings
    case whatsapp
    case pix
    case flag
    case more
    case copy
    case search

    var symbolName: String {
        switch self {
        case .home: "house.fill"
        case .activity: "waveform.path.ecg"
        case .ledger: "list.bullet.rectangle"
        case .profile: "person.crop.circle.fill"
        case .plus: "plus"
        case .chevronRight: "chevron.right"
        case .chevronLeft: "chevron.left"
        case .close: "xmark"
        case .check: "checkmark"
        case .arrowUp: "arrow.up"
        case .arrowDown: "arrow.down"
        case .arrowRight: "arrow.right"
        case .dollar: "dollarsign"
        case .swords: "flag.2.crossed"
        case .receipt: "receipt"
        case .users: "person.2.fill"
        case .shield: "shield.fill"
        case .clock: "clock"
        case .bell: "bell.fill"
        case .send: "paperplane.fill"
        case .camera: "camera.fill"
        case .eye: "eye.fill"
        case .settings: "gearshape.fill"
        case .whatsapp: "message.fill"
        case .pix: "qrcode"
        case .flag: "flag.fill"
        case .more: "ellipsis"
        case .copy: "doc.on.doc"
        case .search: "magnifyingglass"
        }
    }
}

public struct GPIcon: View {
    private let name: GPIconName
    private let size: CGFloat
    private let color: Color

    public init(_ name: GPIconName, size: CGFloat = 20, color: Color = .primary) {
        self.name = name
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: name.symbolName)
            .font(.system(size: size, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
    }
}

#Preview("All Icons") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
            ForEach(GPIconName.allCases, id: \.self) { icon in
                VStack(spacing: 4) {
                    GPIcon(icon, size: 22)
                    Text(icon.rawValue)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}
