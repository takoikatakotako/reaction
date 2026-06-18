import SwiftUI

struct QuestionDetailView: View {
    @StateObject var viewState: QuestionDetailViewState

    var body: some View {
        NavigationStack {
            ZoomableScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title & Difficulty
                    if !viewState.displayTitle.isEmpty || viewState.difficulty > 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            if !viewState.displayTitle.isEmpty {
                                Text(viewState.displayTitle)
                                    .font(Font.system(size: 20).bold())
                            }
                            if viewState.difficulty > 0 {
                                DifficultyStarsView(difficulty: viewState.difficulty)
                            }
                        }
                    }

                    // Question
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Problem")
                            .font(Font.system(size: 16).bold())
                        ForEach(viewState.question.problemImageUrls, id: \.self) { imageUrlString in
                            if let imageUrl = URL(string: imageUrlString) {
                                CommonWebImage(url: imageUrl)
                            }
                        }
                    }

                    if viewState.showSolution {
                        // Solution
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Solution")
                                .font(Font.system(size: 16).bold())
                            ForEach(viewState.question.solutionImageUrls, id: \.self) { imageUrlString in
                                if let imageUrl = URL(string: imageUrlString) {
                                    CommonWebImage(url: imageUrl)
                                }
                            }
                        }

                        if !viewState.question.references.isEmpty {
                            // Reference
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reference")
                                    .font(Font.system(size: 16).bold())
                                ForEach(viewState.question.references, id: \.self) { reference in
                                    if let referenceUrl = URL(string: reference) {
                                        Button {
                                            viewState.referenceTapped(url: referenceUrl)
                                        } label: {
                                            Text(reference)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        Button {
                            viewState.showSolutionTapped()
                        } label: {
                            Text("Show Solution")
                                .font(Font.system(size: 18).bold())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(16)
            }
            .alert(String(localized: "question-detail-open-reference-title"), isPresented: $viewState.showingReferenceAlert, actions: {
                Button(String(localized: "common-open")) {
                    viewState.openSelectedReference()
                }
                Button(String(localized: "common-cancel"), role: .cancel) {}
            }, message: {
                if let url = viewState.selectedReferenceUrl {
                    Text(url.absoluteString)
                }
            })
        }
    }
}
