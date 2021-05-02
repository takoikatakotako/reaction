import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ReactionListView: View {
    @StateObject var viewModel: ReactionListViewModel
    
    init(showingThmbnail: Bool, selectJapanese: Bool) {
        _viewModel = StateObject(wrappedValue: ReactionListViewModel(showingThmbnail: showingThmbnail, selectJapanese: selectJapanese))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack {
                        TextField("Type your search",text: $viewModel.searchText)
                            .padding(8)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        ForEach(viewModel.showingReactions) { (reactionMechanism: ReactionMechanism) in
                            ReactionListRow(reactionMechanism: reactionMechanism, showingThmbnail: $viewModel.showingThmbnail, selectJapanese: $viewModel.selectJapanese)
                        }
                    }
                    .padding(.bottom, 62)
                }
                
                if viewModel.isFetching {
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .padding(36)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(24)
                }
                
                VStack {
                    Spacer()
                    AdmobBannerView(adUnitID: ADMOB_UNIT_ID)
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
                    viewModel.showSetting()
                }, label: {
                    Image("icon-setting")
                })
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionListView(showingThmbnail: true, selectJapanese: false)
    }
}
