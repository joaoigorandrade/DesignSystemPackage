import SwiftUI

public typealias GPPickerRowView = GroupoolSegmentedControl

#Preview("Segmented Picker") {
    @Previewable @State var selected = "6h"
    GPPickerRowView(
        options: ["6h", "12h", "24h", "48h", "72h"],
        selection: $selected,
        title: { $0 }
    )
    .padding()
}
