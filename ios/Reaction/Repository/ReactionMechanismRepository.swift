import SwiftUI

class ReactionMechanismRepository {
    func fetchMechanisms() async throws -> [ReactionMechanism] {
        let url = URL(string: "https://reaction-development.swiswiswift.com/resource/reaction/reactions.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let reactionsResponse = try JSONDecoder().decode(ReactionsResponse.self, from: data)
        return reactionsResponse.reactions
    }
}
