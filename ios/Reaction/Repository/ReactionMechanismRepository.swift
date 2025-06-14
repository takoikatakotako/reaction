import SwiftUI

class ReactionMechanismRepository {
    func fetchMechanisms(reactionsEndpoint: String) async throws -> [ReactionMechanism] {
        let url = URL(string: reactionsEndpoint)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let reactionsResponse = try JSONDecoder().decode(ReactionsResponse.self, from: data)
        return reactionsResponse.reactions
    }
}
