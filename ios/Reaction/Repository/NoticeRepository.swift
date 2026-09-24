import SwiftUI

final class NoticeRepository {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchNotices(noticesEndpoint: String) async throws -> [Notice] {
        guard let url = URL(string: noticesEndpoint) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, _) = try await session.data(for: request)
        let noticesResponse = try JSONDecoder().decode(NoticesResponse.self, from: data)
        return noticesResponse.notices
    }
}
