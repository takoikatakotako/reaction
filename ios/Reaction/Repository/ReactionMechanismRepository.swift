import SwiftUI

class ReactionMechanismRepository {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchMechanisms(reactionsEndpoint: String) async throws -> [ReactionMechanism] {
        let url = URL(string: reactionsEndpoint)!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, _) = try await session.data(for: request)
        let reactionsResponse = try JSONDecoder().decode(ReactionsResponse.self, from: data)
        return reactionsResponse.reactions
    }
}
