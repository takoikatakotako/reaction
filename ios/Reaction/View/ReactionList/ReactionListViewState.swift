import SwiftUI
import Combine

@MainActor
final class ReactionListViewState: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingThumbnail: Bool
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var showingPaywall = false
    @Published var completeAlert = false
    @Published var sheet: ReactionListViewSheet?
    @Published var destination: ReactionMechanism?
    private var unlockedInPaywall = false

    // 反応機構の言語
    @Published var reactionMechanismIdentifier: String

    private let userDefaultsRepository = UserDefaultRepository()
    private let reactionRepository = ReactionMechanismRepository()

    init(showingThumbnail: Bool) {
        self.reactionMechanismIdentifier = userDefaultsRepository.reactionMechanismLanguage
        self.showingThumbnail = showingThumbnail
    }

    var showingReactions: [ReactionMechanism] {
        if searchText.isEmpty {
            return reactionMechanisms
        } else {
            return reactionMechanisms.filter { reactionMechanisms -> Bool in
                for suggestion in reactionMechanisms.suggestions {
                    if suggestion.uppercased().contains(searchText.uppercased()) {
                        return true
                    }
                }
                return false
            }
        }
    }

    func onAppear() {
        reactionMechanismIdentifier = userDefaultsRepository.reactionMechanismLanguage
        showingThumbnail = userDefaultsRepository.showThumbnail

        Task {
            do {
                let fetched = try await reactionRepository.fetchMechanisms(reactionsEndpoint: EnvironmentVariable.shared.reactionsEndpoint)
                if fetched != self.reactionMechanisms {
                    self.reactionMechanisms = fetched
                }
                self.isFetching = false
            } catch {
                self.isFetching = false
            }
        }
    }

    func clearSearchText() {
        searchText = ""
    }

    func tapped(reactionMechanism: ReactionMechanism) {
        guard userDefaultsRepository.enableDetailAbility else {
            // 未課金なので購入画面を表示
            showingPaywall = true
            return
        }

        destination = reactionMechanism
    }

    /// 購入画面で特典が有効になったとき
    func paywallUnlocked() {
        unlockedInPaywall = true
    }

    /// 購入画面が閉じたとき。閉じ終わってからアラートを出さないと表示されないため、ここで出す
    func paywallDismissed() {
        guard unlockedInPaywall else {
            return
        }
        unlockedInPaywall = false
        completeAlert = true
    }
}
