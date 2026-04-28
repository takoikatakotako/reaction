import SwiftUI

class QuestionViewState: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isFetching = true
    @Published var isError = false

    private let questionRepository = QuestionRepository()

    func onAppear() {
        Task { @MainActor in
            do {
                let fetched = try await questionRepository.fetchQuestions(
                    questionsEndpoint: EnvironmentVariable.shared.getQuestionsEndpoint
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
