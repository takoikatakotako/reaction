import SwiftUI
import Combine

class ReactionListViewState: ObservableObject {
    @Published var searchText: String = ""
    @Published var showingThmbnail: Bool
    @Published var selectJapanese: Bool
    @Published var isFetching = true
    @Published var reactionMechanisms: [ReactionMechanism] = []
    @Published var sheet: ReactionListViewSheet?
    @Published var destination: ReactionMechanism?

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
        selectJapanese = userDefaultsRepository.selectedJapanese
        showingThmbnail = userDefaultsRepository.showThmbnail
        guard reactionMechanisms.isEmpty else {
            return
        }
        Task { @MainActor in
            do {
                let reactionMechanisms = try await reactionRepository.fetchMechanisms()
                self.reactionMechanisms = reactionMechanisms
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
        
        
        destination = reactionMechanism
    }
}
