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
                            ReactionListRow(reactionMechanism: reactionMechanism, showingThmbnail: $viewModel.showingThmbnail, selectJapanese: $viewModel.selectJapanese)
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
            .sheet(item: $viewModel.sheet) { (item: ReactionListViewSheet) in
                switch item {
                case .developer:
                    DeveloperView()
                case .config:
                    ReactionListConfigView(showingThmbnail: $viewModel.showingThmbnail, selectJapanese: $viewModel.selectJapanese)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewModel.sheet = .developer
                }, label: {
                    Text("Info")
                }),
                trailing: Button(action: {
                    viewModel.showxxx()
                }, label: {
                    Image("icon-setting")
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionListView()
    }
}