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
                    ForEach(viewState.question.problemImageNames, id: \.self) { imageName in
                        Button {
                            viewState.imageTapped(imageName: imageName)
                        } label: {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    
                    // Solution
                    Text("Solution")
                        .font(Font.system(size: 16).bold())
                    if viewState.showSolution {
                        ForEach(viewState.question.solutionImageNames, id: \.self) { imageName in
                            Button {
                                viewState.imageTapped(imageName: imageName)
                            } label: {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
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
            .sheet(item: $viewState.sheet) { item in
                switch item {
                case .imageViewer(imageName: let imageName):
                    ImageViewer(imageName: imageName)
                }
            }
        }
    }
}
//
//#Preview {
//    QuestionDetailView()
//}
