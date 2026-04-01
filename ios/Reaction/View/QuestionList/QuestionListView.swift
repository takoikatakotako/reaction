import SwiftUI

struct QuestionListView: View {
    @StateObject var viewState: QuestionViewState

    var body: some View {
        NavigationStack {
            List(viewState.questions) { question in
                if let imageUrlString = question.problemImageUrls.first,
                   let imageUrl = URL(string: imageUrlString) {
                    NavigationLink {
                        QuestionDetailView(viewState: QuestionDetailViewState(question: question))
                    } label: {
                        CommonWebImage(url: imageUrl)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(String(localized: "common-study"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewState.onAppear()
        }
    }
}

#Preview {
    QuestionListView(viewState: QuestionViewState())
}
