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
    
    private let userDefaultsRepository = UserDefaultRepository()
    private let reactionRepository = ReactionMechanismRepository()
    private var subscriptions = Set<AnyCancellable>()

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
    
    func onAppear() {
        setting()
        if reactionMechanisms.isEmpty {
            fetchMechanisms()
        }
        requestTrackingAuthorizationStatus()
    }
        
    func clearSearchText() {
        searchText = ""
    }
    
    func showSetting() {
        self.sheet = .config
    }
    
    private func setting() {
        selectJapanese = userDefaultsRepository.selectedJapanese
        showingThmbnail = userDefaultsRepository.showThmbnail
    }
    
    private func requestTrackingAuthorizationStatus() {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized: break
        case .denied: break
        case .restricted: break
        case .notDetermined:
            showTrackingAuthorization()
        @unknown default: break
        }
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
                self.reactionMechanisms = reactionMechanisms
            })
            .store(in: &self.subscriptions)
    }
    
    private func showTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}
