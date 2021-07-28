import SwiftUI
import Combine

class SearchResultViewModel: ObservableObject {
    @Published var showingThmbnail: Bool = true
    @Published var selectJapanese: Bool = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    private let reactionRepository = ReactionMechanismRepository()
    private var subscriptions = Set<AnyCancellable>()
    private let userDefaultsRepository = UserDefaultRepository()
    private let searchResultType: SearchTargetType
    private let withoutCheck: Bool
    private let firstCategories: [FirstCategory]
    
    var navigationTitle: String {
        switch searchResultType {
        case .reactant:
            return "Search Reactant"
        case .product:
            return "Search Product"
        }
    }
    
    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        self.searchResultType = searchResultType
        self.withoutCheck = withoutCheck
        self.firstCategories = firstCategories
    }
    
    func onAppear() {
        setting()
        if reactionMechanisms.isEmpty {
            fetchMechanisms()
        }
    }
    
    private func setting() {
        selectJapanese = userDefaultsRepository.selectedJapanese
        showingThmbnail = userDefaultsRepository.showThmbnail
    }
    
    private func fetchMechanisms() {
        reactionRepository
            .fetchMechanisms()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isFetching = false
                    break
                case let .failure(error):
                    self.isFetching = false
                    print(error.localizedDescription)
                    break
                }
            }, receiveValue: { reactionMechanisms in
                // 検索結果を取得
                if self.withoutCheck {
                    // チェックしたもの以外を検索
                    self.reactionMechanisms = self.searchReactionsWithoutCheck(originalReactionMechanism: reactionMechanisms)
                } else {
                    // チェックしたものを検索
                    self.reactionMechanisms = self.searchReactionsWithCheck(originalReactionMechanism: reactionMechanisms)
                }
            })
            .store(in: &self.subscriptions)
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
                        tags.append(thirdCategory.name)
                    }
                }
            }
        }
        return tags
    }
    
    // 反応機構検索。チェックしたものを検索
    private func searchReactionsWithCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filterdReactionMechanisms: Set<ReactionMechanism> = []
        for reactionMechanism in originalReactionMechanism {
            for tag in self.getTags() {
                // 出発物検索
                if searchResultType == .reactant {
                    if reactionMechanism.reactants.firstIndex(where: {$0 == tag}) != nil {
                        filterdReactionMechanisms.insert(reactionMechanism)
                    }
                }
                // 生成物検索
                if searchResultType == .product {
                    if reactionMechanism.products.firstIndex(where: {$0 == tag}) != nil {
                        filterdReactionMechanisms.insert(reactionMechanism)
                    }
                }
            }
        }
        return sorted(Array(filterdReactionMechanisms))
    }
    
    // 反応機構検索。チェックしたものを除外
    private func searchReactionsWithoutCheck(originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        var filterdReactionMechanisms: [ReactionMechanism] = originalReactionMechanism
        // チェックしたものを取得
        let searchReactionsWithChecks = searchReactionsWithCheck(originalReactionMechanism: originalReactionMechanism)
        // チェックしたものを除いていく
        for searchReactionsWithCheck in searchReactionsWithChecks {
            if let index = filterdReactionMechanisms.firstIndex(where: {$0 == searchReactionsWithCheck}) {
                filterdReactionMechanisms.remove(at: index)
            }
        }
        return sorted(filterdReactionMechanisms)
    }
    
    private func sorted(_ originalReactionMechanism: [ReactionMechanism]) -> [ReactionMechanism] {
        return originalReactionMechanism.sorted(by: { lhs, rhs in
            lhs.directoryName < rhs.directoryName
        })
    }
}
