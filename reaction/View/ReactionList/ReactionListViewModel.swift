import SwiftUI
import Combine

class ReactionListViewModel: ObservableObject {
    @Published var showingThmbnail = true
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var showingDeveloperSheet = false
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
}
