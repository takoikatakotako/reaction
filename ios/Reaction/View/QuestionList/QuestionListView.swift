import SwiftUI

struct QuestionListView: View {
    @StateObject var viewState: QuestionViewState

    var body: some View {
        NavigationStack {
            List(viewState.questions){ question in
                if let problemName = question.problemImageNames.first {
                    NavigationLink {
                        QuestionDetailView(viewState: QuestionDetailViewState(question: question))
                    } label: {
                        Image(problemName)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(String(localized: "common-study"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuestionListView(viewState: QuestionViewState())
}
