import SwiftUI
import Combine

class SearchResultViewModel: ObservableObject {
    @Published var showingThmbnail: Bool = true
    @Published var selectJapanese: Bool = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    private let reactionRepository = ReactionMechanismRepository()
    private var subscriptions = Set<AnyCancellable>()
    
    private let searchResultType: SearchTargetType
    private let withoutCheck: Bool
    private let firstCategories: [FirstCategory]
    
    init(searchResultType: SearchTargetType, withoutCheck: Bool, firstCategories: [FirstCategory]) {
        self.searchResultType = searchResultType
        self.withoutCheck = withoutCheck
        self.firstCategories = firstCategories
    }
    
    func fetchMechanisms() {
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
                // ここで何を探すのか検索する。
                
                self.reactionMechanisms = reactionMechanisms
                    .filter({ reactionMechanism in
                        if reactionMechanism.products.firstIndex(where: {$0 == "xxx"}) != nil {
                            return true
                        }
                        return false
                    })
                
                
                
                self.reactionMechanisms = reactionMechanisms
            })
            .store(in: &self.subscriptions)
    }
}
