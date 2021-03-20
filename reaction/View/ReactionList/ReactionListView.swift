import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ReactionListView: View {
    @StateObject var viewModel = ReactionListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.reactionMechanisms) { (reactionMechanism: ReactionMechanism) in
                            ReactionListRow(reactionMechanism: reactionMechanism, showingThmbnail: $viewModel.showingThmbnail)
                        }
                    }
                }
                
                if viewModel.isFetching {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .padding(36)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(24)
                }
            }
            .onAppear {
                viewModel.searchRepos()
            }
            .sheet(isPresented: $viewModel.showingDeveloperSheet) {
                DeveloperView()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewModel.showingDeveloperSheet = true
                }, label: {
                    Image("icon-setting")
                }),
                
                trailing: Button("Thmbnail") {
                    viewModel.showingThmbnail.toggle()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionListView()
    }
}
