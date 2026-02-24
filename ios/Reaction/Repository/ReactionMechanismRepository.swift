import SwiftUI

class ReactionMechanismRepository {
    func fetchMechanisms(reactionsEndpoint: String) async throws -> [ReactionMechanism] {
        let url = URL(string: reactionsEndpoint)!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let (data, _) = try await URLSession.shared.data(for: request)
        let reactionsResponse = try JSONDecoder().decode(ReactionsResponse.self, from: data)
        return reactionsResponse.reactions
    }
}
