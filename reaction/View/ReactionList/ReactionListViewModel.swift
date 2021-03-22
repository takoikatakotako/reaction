import SwiftUI
import Combine

enum ReactionListViewSheet: Identifiable {
    var id: Int {
        hashValue
    }
    case developer
    case config
}

class ReactionListViewModel: ObservableObject {
    @Published var showingThmbnail = true
    @Published var selectJapanese = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var sheet: ReactionListViewSheet?
    private var subscriptions = Set<AnyCancellable>()
    
    func searchRepos() {
        let url = URL(string: "https://chemist.swiswiswift.com/reactions.json")!
        
        struct Json: Decodable {
            let reactions: [ReactionMechanism]
        }
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(Json.self, from: $0.data).reactions }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
    
    func showxxx() {
        self.sheet = .config
    }
}
