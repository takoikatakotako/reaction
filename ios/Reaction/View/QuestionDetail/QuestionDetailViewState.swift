import SwiftUI

class QuestionDetailViewState: ObservableObject {
    let question: Question

    @Published var showSolution: Bool = false
    @Published var showingReferenceAlert: Bool = false
    @Published var selectedReferenceUrl: URL?

    init(question: Question) {
        self.question = question
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
