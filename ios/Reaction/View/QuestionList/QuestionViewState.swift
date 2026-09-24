import SwiftUI

@MainActor
final class QuestionViewState: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isFetching = true
    @Published var isError = false

    private let questionRepository = QuestionRepository()

    func onAppear() {
        Task {
            do {
                let fetched = try await questionRepository.fetchQuestions(
                    questionsEndpoint: EnvironmentVariable.shared.questionsEndpoint
                )
                if fetched != self.questions {
                    self.questions = fetched
                }
                self.isFetching = false
            } catch {
                self.isFetching = false
                self.isError = true
            }
        }
    }
}
