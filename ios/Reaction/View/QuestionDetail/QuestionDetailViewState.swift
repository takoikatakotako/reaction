import SwiftUI

class QuestionDetailViewState: ObservableObject {
    let question: Question
    
    @Published var showSolution: Bool = false
    
    init(question: Question) {
        self.question = question
    }
    
}
