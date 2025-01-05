import SwiftUI
import Combine

class ReactionMechanismRepository {
    func fetchMechanisms() async throws -> [ReactionMechanism] {
        let url = URL(string: "https://chemist.swiswiswift.com/resource/reactions.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let reactions = try JSONDecoder().decode([ReactionMechanism].self, from: data)
        return reactions.sorted { lhs, rhs in
            lhs.directoryName < rhs.directoryName
        }
    }
}
