import SwiftUI

class ReactionMechanismRepository {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMechanisms(reactionsEndpoint: String) async throws -> [ReactionMechanism] {
        guard let url = URL(string: reactionsEndpoint) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, _) = try await session.data(for: request)
        let reactionsResponse = try JSONDecoder().decode(ReactionsResponse.self, from: data)
        return reactionsResponse.reactions
    }
}
