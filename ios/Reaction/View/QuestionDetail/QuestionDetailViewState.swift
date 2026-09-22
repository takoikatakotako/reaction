import SwiftUI

class QuestionDetailViewState: ObservableObject {
    let question: Question

    @Published var showSolution: Bool = false
    @Published var showingReferenceAlert: Bool = false
    @Published var selectedReferenceUrl: URL?

    // タイトルの表示言語は反応機構名と同じ設定に準拠する
    let reactionMechanismIdentifier: String

    private let userDefaultRepository = UserDefaultRepository()

    init(question: Question) {
        self.question = question
        self.reactionMechanismIdentifier = userDefaultRepository.reactionMechanismLanguage
    }

    var displayTitle: String {
        question.getDisplayTitle(identifier: reactionMechanismIdentifier)
    }

    var difficulty: Int {
        question.difficulty ?? 0
    }

    func showSolutionTapped() {
        showSolution = true
    }

    func referenceTapped(url: URL) {
        selectedReferenceUrl = url
        showingReferenceAlert = true
    }

    func openSelectedReference() {
        guard let url = selectedReferenceUrl else { return }
        UIApplication.shared.open(url)
    }
}
