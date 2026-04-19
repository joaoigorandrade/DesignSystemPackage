import SwiftUI

public struct GPStepperView: View {
    @Environment(\.groupoolTheme) private var theme

    private let currentStep: Int
    private let totalSteps: Int
    private let stepTitles: [String]

    public init(currentStep: Int, totalSteps: Int, stepTitles: [String] = []) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.stepTitles = stepTitles
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                stepCircle(index: index)
                if index < totalSteps - 1 {
                    Rectangle()
                        .fill(index < currentStep - 1 ? theme.pool : theme.lineSecondary)
                        .frame(height: 2)
                }
            }
        }
    }

    private func stepCircle(index: Int) -> some View {
        let isCompleted = index < currentStep - 1
        let isCurrent = index == currentStep - 1

        return ZStack {
            Circle()
                .fill(isCompleted || isCurrent ? theme.pool : theme.lineSecondary)
                .frame(width: 28, height: 28)
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                Text("\(index + 1)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isCurrent ? .white : theme.inkTertiary)
            }
        }
    }
}

#Preview("Stepper") {
    VStack(spacing: 20) {
        GPStepperView(currentStep: 1, totalSteps: 5)
        GPStepperView(currentStep: 3, totalSteps: 5)
        GPStepperView(currentStep: 5, totalSteps: 5)
    }
    .padding()
}
