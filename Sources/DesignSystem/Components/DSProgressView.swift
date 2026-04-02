import SwiftUI

public struct DSProgressView: View {
    public struct Progress: Identifiable, Hashable {
        public struct Label: Hashable {
            public let icon: BrandIcon
            public let text: String
            
            public init(icon: BrandIcon, text: String) {
                self.icon = icon
                self.text = text
            }
        }
        
        public let id: UUID
        public let title: String
        public let body: String
        public let label: Label
        
        public init(id: UUID = UUID(), title: String, body: String, label: Label) {
            self.id = id
            self.title = title
            self.body = body
            self.label = label
        }
    }
    
    public let progress: [Progress]
    public let currentIndex: Int
    
    public init(progress: [Progress], currentIndex: Int) {
        self.progress = progress
        self.currentIndex = currentIndex
    }
    
    private var selectedIndex: Int {
        guard !progress.isEmpty else {
            return 0
        }
        
        return min(max(0, currentIndex), progress.count - 1)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(progress.enumerated()), id: \.element.id) { index, item in
                ProgressRow(
                    index: index,
                    item: item,
                    totalSteps: progress.count,
                    selectedIndex: selectedIndex
                )
            }
        }
    }
}

private struct ProgressRow: View {
    let index: Int
    let item: DSProgressView.Progress
    let totalSteps: Int
    let selectedIndex: Int
    
    private var isSelected: Bool {
        index == selectedIndex
    }
    
    private var isCompleted: Bool {
        index <= selectedIndex
    }
    
    private var showsConnector: Bool {
        index < totalSteps - 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            header
            description
        }
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 6) {
            stepIndicator
            title
            Spacer(minLength: 4)
            DSProgressLabelView(label: item.label)
        }
    }
    
    private var stepIndicator: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color.brandPrimary.opacity(0.2) : .clear)
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: 2)
                        .shadow(color: borderColor, radius: 8)
                )
                .frame(width: 32, height: 32)
            
            Text("\(index + 1)")
                .font(.dsHeadline)
                .fontWeight(.semibold)
                .foregroundStyle(isCompleted ? Color.brandPrimary : Color.coolGrey)
        }
    }
    
    private var title: some View {
        Text(item.title)
            .dsHeadline()
            .foregroundStyle(isSelected ? Color.primary : Color.primary.opacity(0.92))
    }
    
    private var description: some View {
        bodyText
            .overlay(alignment: .leading) {
                if showsConnector {
                    Rectangle()
                        .fill(connectorColor)
                        .shadow(color: borderColor, radius: 8)
                        .frame(width: 2)
                        .offset(x: -14)
                }
            }
            .padding(.leading, 14)
        .padding(.leading, 16)
    }
    
    private var bodyText: some View {
        Text(item.body)
            .dsFootnote()
            .foregroundStyle(Color.coolGrey)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .padding(.leading, 8)
            .padding(.bottom, 16)
    }
    
    private var borderColor: Color {
        isCompleted ? Color.brandPrimary : Color.coolGrey.opacity(0.35)
    }
    
    private var connectorColor: Color {
        isCompleted ? Color.brandPrimary.opacity(0.45) : Color.coolGrey.opacity(0.25)
    }
}

private struct DSProgressLabelView: View {
    let label: DSProgressView.Progress.Label
    
    var body: some View {
        HStack(spacing: 4) {
            label.icon
                .view(scale: .small)
            
            Text(label.text)
                .font(.dsCaption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .foregroundStyle(Color.success)
        .padding(.horizontal, 10)
        .padding(.vertical, 2)
        .background(Color.success.opacity(0.14))
        .clipShape(Capsule(style: .continuous))
    }
}


struct DSProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.backgroundGrey,
                    Color.brandPrimary.opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            DSProgressView(
                progress: [
                    .init(
                        title: "Enter Your Number",
                        body: "Input your mobile credentials above",
                        label: .init(icon: .checkmark, text: "Started")
                    ),
                    .init(
                        title: "OTP Sent Securely",
                        body: "Verification code delivered via encrypted tunnel",
                        label: .init(icon: .info, text: "Instant Sync")
                    ),
                    .init(
                        title: "Verify Identity",
                        body: "Final handshake with secure vault",
                        label: .init(icon: .target, text: "E2E Verification")
                    )
                ],
                currentIndex: 0
            )
            .padding(20)
        }
    }
}
