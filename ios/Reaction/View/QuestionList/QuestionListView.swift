import SwiftUI

struct QuestionListView: View {
    @StateObject var viewState: QuestionViewState

    var body: some View {
        NavigationStack {
            List(viewState.questions){ question in
                NavigationLink {
                    QuestionDetailView(viewState: QuestionDetailViewState(question: question))
                } label: {
                    Image(question.problemImageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    QuestionListView(viewState: QuestionViewState())
}
