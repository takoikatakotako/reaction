import SwiftUI
import Combine

class SearchResultViewModel: ObservableObject {
    @Published var showingThmbnail: Bool = false
    @Published var selectJapanese: Bool = false
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    private let reactionRepository = ReactionMechanismRepository()
    private var subscriptions = Set<AnyCancellable>()
    
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
                self.reactionMechanisms = reactionMechanisms
            })
            .store(in: &self.subscriptions)
    }
}
