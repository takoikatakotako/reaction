import SwiftUI

class QuestionRepository {
    func fetchQuestions(questionsEndpoint: String) async throws -> [Question] {
        let url = URL(string: questionsEndpoint)!
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, _) = try await URLSession.shared.data(for: request)
        let questionsResponse = try JSONDecoder().decode(QuestionsResponse.self, from: data)
        return questionsResponse.questions
    }
}
