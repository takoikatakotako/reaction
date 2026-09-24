import SwiftUI

struct NoticeDetailView: View {
    let notice: Notice
    let identifier: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CommonText(text: notice.displayDate, font: Font.system(size: 12))
                    .foregroundStyle(.secondary)

                Text(notice.getDisplayTitle(identifier: identifier))
                    .font(Font.system(size: 20).bold())

                Text(notice.getDisplayBody(identifier: identifier))
                    .font(Font.system(size: 16))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .navigationTitle(String(localized: "notice-title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
