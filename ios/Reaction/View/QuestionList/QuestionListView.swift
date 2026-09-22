import SwiftUI

struct QuestionListView: View {
    @StateObject var viewState: QuestionViewState

    var body: some View {
        NavigationStack {
            Group {
                if viewState.isError {
                    Text(String(localized: "common-error-message"))
                        .foregroundStyle(.secondary)
                } else {
                    List(viewState.questions) { question in
                        if let imageUrlString = question.problemImageUrls.first,
                           let imageUrl = URL(string: imageUrlString) {
                            NavigationLink {
                                QuestionDetailView(viewState: QuestionDetailViewState(question: question))
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(question.displayNumber)
                                        .font(Font.system(size: 14))
                                        .foregroundStyle(.secondary)
                                    let difficulty = question.difficulty ?? 0
                                    if difficulty > 0 {
                                        DifficultyStarsView(difficulty: difficulty)
                                    }
                                    CommonWebImage(url: imageUrl)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
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
