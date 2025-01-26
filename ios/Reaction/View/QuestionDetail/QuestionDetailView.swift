import SwiftUI

struct QuestionDetailView: View {
    @StateObject var viewState: QuestionDetailViewState
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("Problem")
                
                Image(viewState.question.problemImageName)
                    .resizable()
                    .scaledToFit()
                
                Text("Solution")
                
                
                Button {
                    
                    viewState.showSolution.toggle()
                    print(viewState.showSolution)
                } label: {
                    ZStack {
                        Image(viewState.question.solutionImageName)
                            .resizable()
                            .scaledToFit()
                        
                        if !viewState.showSolution {
                            ZStack {
                                Color.gray
                                Text("Show Solution")
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    QuestionDetailView()
//}
