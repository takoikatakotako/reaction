import SwiftUI

struct NoticeListView: View {
    @StateObject var viewState: NoticeListViewState

    var body: some View {
        Group {
            if viewState.isFetching {
                ProgressView()
            } else if viewState.isError {
                CommonText(text: String(localized: "notice-fetch-error"), font: Font.system(size: 14))
            } else if viewState.notices.isEmpty {
                CommonText(text: String(localized: "notice-empty"), font: Font.system(size: 14))
            } else {
                List(viewState.notices) { notice in
                    NavigationLink {
                        NoticeDetailView(
                            notice: notice,
                            identifier: viewState.reactionMechanismIdentifier
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            CommonText(text: notice.displayDate, font: Font.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text(notice.getDisplayTitle(identifier: viewState.reactionMechanismIdentifier))
                                .font(Font.system(size: 16))
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            viewState.onAppear()
        }
        .navigationTitle(String(localized: "notice-title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NoticeListView(viewState: NoticeListViewState())
    }
}
