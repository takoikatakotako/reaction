import SwiftUI

class QuestionDetailViewState: ObservableObject {
    let question: Question

    @Published var showSolution: Bool = false
    @Published var sheet: QuestionDetailViewSheet?

    init(question: Question) {
        self.question = question
    }

    func showSolutionTapped() {
        showSolution = true
    }

    func imageTapped(imageUrlString: String) {
        sheet = .imageViewer(imageUrlString: imageUrlString)
    }
}
