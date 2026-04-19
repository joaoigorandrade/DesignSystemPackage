import SwiftUI

public typealias GPListRowView = GroupoolListRow

#Preview("List Rows") {
    VStack(spacing: 0) {
        GPListRowView {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .frame(width: 36, height: 36)
        } content: {
            Text("Favorito")
        } trailing: {
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
        GPListRowView(showsDivider: false) {
            Image(systemName: "bell.fill")
                .foregroundStyle(.orange)
                .frame(width: 36, height: 36)
        } content: {
            Text("Notificações")
        } trailing: {
            Image(systemName: "chevron.right").foregroundStyle(.tertiary)
        }
    }
    .clipShape(RoundedRectangle(cornerRadius: 18))
}
