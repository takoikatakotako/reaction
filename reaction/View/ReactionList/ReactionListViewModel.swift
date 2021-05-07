import SwiftUI
import Combine
import AdSupport
import AppTrackingTransparency

enum ReactionListViewSheet: Identifiable {
    var id: Int {
        hashValue
    }
    case developer
    case config
}

class ReactionListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingThmbnail: Bool
    @Published var selectJapanese: Bool
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var sheet: ReactionListViewSheet?
    
    init(showingThmbnail: Bool, selectJapanese: Bool) {
        self.showingThmbnail = showingThmbnail
        self.selectJapanese = selectJapanese
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
    
    private var subscriptions = Set<AnyCancellable>()
    
    func searchRepos() {
        let url = URL(string: "https://chemist.swiswiswift.com/resource/reactions.json")!
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode([ReactionMechanism].self, from: $0.data) }
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
    
    func clearSearchText() {
        searchText = ""
    }
    
    func showSetting() {
        self.sheet = .config
    }
    
    func requestTrackingAuthorizationStatus() {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized: break
        case .denied: break
        case .restricted: break
        case .notDetermined:
            showTrackingAuthorization()
        @unknown default: break
        }
    }
    
    private func showTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}
