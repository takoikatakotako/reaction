import SwiftUI

struct RootView: View {
    @StateObject var viewState: RootViewState
    var body: some View {
        TabView {
            ReactionListView(showingThmbnail: viewState.showThmbnail, selectJapanese: viewState.selectedJapanese)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("List")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            ConfigView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Config")
                }
        }
    }
}

#Preview {
    RootView(viewState: RootViewState())
}
