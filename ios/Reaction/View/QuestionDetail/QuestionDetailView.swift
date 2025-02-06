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
                    
                    if viewState.showSolution {
                        // Solution
                        Text("Solution")
                            .font(Font.system(size: 16).bold())
                        ForEach(viewState.question.solutionImageNames, id: \.self) { imageName in
                            Button {
                                viewState.imageTapped(imageName: imageName)
                            } label: {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        
                        // Refarence
                        Text("Refarence")
                            .font(Font.system(size: 16).bold())
                        
                        ForEach(viewState.question.references, id: \.self) { refarence in
                            if let refarenceUrl = URL(string: refarence) {
                                Button {
                                    UIApplication.shared.open(refarenceUrl)
                                } label: {
                                    Text(refarence)
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
            .sheet(item: $viewState.sheet) { item in
                switch item {
                case .imageViewer(imageName: let imageName):
                    ImageViewer(imageName: imageName)
                }
            }
        }
    }
}
