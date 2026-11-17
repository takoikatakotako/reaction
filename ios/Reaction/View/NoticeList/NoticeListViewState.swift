import SwiftUI

@MainActor
final class NoticeListViewState: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var isFetching = true
    @Published var isError = false

    // タイトル・本文・対象言語の判定はアプリの表示言語に従う。
    // 反応機構名の言語設定は化学の用語をどちらで見るかの設定で、既定が英語のため、
    // そちらに合わせるとアプリを日本語で使っていてもお知らせが英語になってしまう。
    let languageIdentifier: String

    private let noticeRepository: NoticeRepository

    init(noticeRepository: NoticeRepository = NoticeRepository(),
         languageIdentifier: String = Bundle.main.preferredLocalizations.first ?? "en") {
        self.noticeRepository = noticeRepository
        self.languageIdentifier = languageIdentifier
    }

    func onAppear() {
        Task {
            do {
                // 対象 OS の絞り込みは配信側（ios.json）で済んでいるので、ここでは言語だけ見る
                let fetched = try await noticeRepository.fetchNotices(
                    noticesEndpoint: EnvironmentVariable.shared.noticesEndpoint
                ).filter { $0.isTarget(identifier: languageIdentifier) }
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
