import SwiftUI

@MainActor
final class SearchResultViewState: ObservableObject {
    @Published var showingThumbnail: Bool = true
    @Published var selectJapanese: Bool = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var showingPaywall = false
    @Published var completeAlert = false
    @Published var destination: ReactionMechanism?
    private var unlockedInPaywall = false

    private let reactionRepository = ReactionMechanismRepository()
    private let userDefaultsRepository = UserDefaultRepository()
    private let searchResultType: SearchTargetType
    private let withoutCheck: Bool
    private let firstCategories: [FirstCategory]

    var navigationTitle: String {
        switch searchResultType {
        case .reactant:
            return String(localized: "search-result-search-reactant")
        case .product:
            return String(localized: "search-result-search-product")
        }
    }

    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        self.searchResultType = searchResultType
        self.withoutCheck = withoutCheck
        self.firstCategories = firstCategories
    }

    func onAppear() {
        showingThumbnail = userDefaultsRepository.showThumbnail

        guard reactionMechanisms.isEmpty else {
            return
        }
        Task {
            do {
                let reactionMechanisms = try await reactionRepository.fetchMechanisms(reactionsEndpoint: EnvironmentVariable.shared.reactionsEndpoint)
                // 検索結果を取得
                if self.withoutCheck {
                    // チェックしたもの以外を検索
                    self.reactionMechanisms = self.searchReactionsWithoutCheck(originalReactionMechanism: reactionMechanisms)
                } else {
                    // チェックしたものを検索
                    self.reactionMechanisms = self.searchReactionsWithCheck(originalReactionMechanism: reactionMechanisms)
                }
                self.isFetching = false
            } catch {
                self.isFetching = false
            }
        }
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

    private func getTags() -> [String] {
        var tags: [String] = []
        for firstCategory in firstCategories {
            if firstCategory.check {
                tags.append(firstCategory.tag)
            }
            for secondCategory in firstCategory.secondCategories {
                if secondCategory.check {
                    tags.append(secondCategory.tag)
                }
                for thirdCategory in secondCategory.thirdCategories {
                    if thirdCategory.check {
                        tags.append(thirdCategory.tag)
                    }
                }
            }
        }
        return tags
    }

    // 反応機構検索。チェックしたものを検索
    private func searchReactionsWithCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filteredReactionMechanisms: Set<ReactionMechanism> = []
        for reactionMechanism in originalReactionMechanism {
            for tag in self.getTags() {
                // 出発物検索
                if searchResultType == .reactant {
                    if reactionMechanism.reactants.firstIndex(where: {$0 == tag}) != nil {
                        filteredReactionMechanisms.insert(reactionMechanism)
                    }
                }
                // 生成物検索
                if searchResultType == .product {
                    if reactionMechanism.products.firstIndex(where: {$0 == tag}) != nil {
                        filteredReactionMechanisms.insert(reactionMechanism)
                    }
                }
            }
        }
        return sorted(Array(filteredReactionMechanisms))
    }

    // 反応機構検索。チェックしたものを除外
    private func searchReactionsWithoutCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filteredReactionMechanisms: [ReactionMechanism] = originalReactionMechanism
        // チェックしたものを取得
        let searchReactionsWithChecks = searchReactionsWithCheck(originalReactionMechanism: originalReactionMechanism)
        // チェックしたものを除いていく
        for searchReactionsWithCheck in searchReactionsWithChecks {
            if let index = filteredReactionMechanisms.firstIndex(where: {$0 == searchReactionsWithCheck}) {
                filteredReactionMechanisms.remove(at: index)
            }
        }
        return sorted(filteredReactionMechanisms)
    }

    private func sorted(_ originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        return originalReactionMechanism.sorted(by: { lhs, rhs in
            lhs.englishName < rhs.englishName
        })
    }
}
