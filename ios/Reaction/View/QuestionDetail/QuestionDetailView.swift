import SwiftUI

struct QuestionDetailView: View {
    @StateObject var viewState: QuestionDetailViewState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // Question
                    Text("Problem")
                        .font(Font.system(size: 16))
                    ForEach(viewState.question.problemImageUrls, id: \.self) { imageUrlString in
                        if let imageUrl = URL(string: imageUrlString) {
                            Button {
                                viewState.imageTapped(imageUrlString: imageUrlString)
                            } label: {
                                CommonWebImage(url: imageUrl)
                            }
                        }
                    }

                    if viewState.showSolution {
                        // Solution
                        Text("Solution")
                            .font(Font.system(size: 16).bold())
                        ForEach(viewState.question.solutionImageUrls, id: \.self) { imageUrlString in
                            if let imageUrl = URL(string: imageUrlString) {
                                Button {
                                    viewState.imageTapped(imageUrlString: imageUrlString)
                                } label: {
                                    CommonWebImage(url: imageUrl)
                                }
                            }
                        }

                        if !viewState.question.references.isEmpty {
                            // Reference
                            Text("Reference")
                                .font(Font.system(size: 16).bold())

                            ForEach(viewState.question.references, id: \.self) { reference in
                                if let referenceUrl = URL(string: reference) {
                                    Button {
                                        UIApplication.shared.open(referenceUrl)
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
            .fullScreenCover(item: $viewState.sheet) { item in
                switch item {
                case .imageViewer(imageUrlString: let imageUrlString):
                    if let imageUrl = URL(string: imageUrlString) {
                        CommonWebImageViewer(url: imageUrl)
                    }
                }
            }
        }
    }
}
