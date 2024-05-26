import SwiftUI

struct RootView: View {
    @StateObject var viewState: RootViewState

    var body: some View {
        TabView {
            ReactionListView(viewState: ReactionListViewState(
                showingThmbnail: viewState.showThmbnail,
                selectJapanese: viewState.selectedJapanese)
            )
            .tabItem {
                Image(systemName: "list.dash")
                Text("List")
            }
            SearchView(viewState: SearchViewState())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            ConfigView(viewState: ConfigViewState())
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
