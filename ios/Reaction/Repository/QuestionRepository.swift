import SwiftUI

class QuestionRepository {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchQuestions(questionsEndpoint: String) async throws -> [Question] {
        guard let url = URL(string: questionsEndpoint) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, _) = try await session.data(for: request)
        let questionsResponse = try JSONDecoder().decode(QuestionsResponse.self, from: data)
        return questionsResponse.questions
    }
}
