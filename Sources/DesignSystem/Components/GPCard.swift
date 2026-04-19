import SwiftUI

public typealias GPCard = GroupoolCard
public typealias GPSectionHeader = GroupoolSectionHeader
public typealias GPListRow = GroupoolListRow

#Preview("Card") {
    VStack(spacing: 16) {
        GPCard {
            VStack(alignment: .leading, spacing: 8) {
                GPSectionHeader("Pool Stats", trailing: "Ver tudo")
                Text("Some card content goes here.")
                    .foregroundStyle(.secondary)
            }
        }
        GPCard(padding: 0) {
            VStack(spacing: 0) {
                GPListRow {
                    Image(systemName: "person.fill")
                        .frame(width: 32)
                } content: {
                    Text("Item One")
                } trailing: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                GPListRow(showsDivider: false) {
                    Image(systemName: "person.fill")
                        .frame(width: 32)
                } content: {
                    Text("Item Two")
                } trailing: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
    .padding()
}
