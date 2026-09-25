import SwiftUI

@MainActor
final class NoticeListViewState: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var isFetching = true
    @Published var isError = false

    // タイトル・本文の表示言語は反応機構名と同じ設定に準拠する
    let reactionMechanismIdentifier: String

    private let noticeRepository: NoticeRepository

    init(noticeRepository: NoticeRepository = NoticeRepository(),
         userDefaultRepository: UserDefaultRepository = UserDefaultRepository()) {
        self.noticeRepository = noticeRepository
        self.reactionMechanismIdentifier = userDefaultRepository.reactionMechanismLanguage
    }

    func onAppear() {
        Task {
            do {
                let fetched = try await noticeRepository.fetchNotices(
                    noticesEndpoint: EnvironmentVariable.shared.noticesEndpoint
                )
                if fetched != notices {
                    notices = fetched
                }
                isFetching = false
            } catch {
                isFetching = false
                isError = true
            }
        }
    }
}
