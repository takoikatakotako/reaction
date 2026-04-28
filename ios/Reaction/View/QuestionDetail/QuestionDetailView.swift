import SwiftUI

struct QuestionDetailView: View {
    @StateObject var viewState: QuestionDetailViewState

    var body: some View {
        NavigationStack {
            ZoomableScrollView {
                VStack(alignment: .leading) {
                    // Question
                    Text("Problem")
                        .font(Font.system(size: 16))
                    ForEach(viewState.question.problemImageUrls, id: \.self) { imageUrlString in
                        if let imageUrl = URL(string: imageUrlString) {
                            CommonWebImage(url: imageUrl)
                        }
                    }

                    if viewState.showSolution {
                        // Solution
                        Text("Solution")
                            .font(Font.system(size: 16).bold())
                        ForEach(viewState.question.solutionImageUrls, id: \.self) { imageUrlString in
                            if let imageUrl = URL(string: imageUrlString) {
                                CommonWebImage(url: imageUrl)
                            }
                        }

                        if !viewState.question.references.isEmpty {
                            // Reference
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
                    } else {
                        HStack {
                            Spacer()

                            Button {
                                viewState.showSolutionTapped()
                            } label: {
                                Text("Show Solution")
                                    .font(Font.system(size: 16))
                            }

                            Spacer()
                        }
                    }
                }
                .padding(8)
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
