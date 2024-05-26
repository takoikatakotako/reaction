import SwiftUI
import Combine

class ReactionMechanismRepository {
    func fetchMechanisms() async throws -> [ReactionMechanism] {
        let url = URL(string: "https://chemist.swiswiswift.com/resource/reactions.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ReactionMechanism].self, from: data)
    }
}
