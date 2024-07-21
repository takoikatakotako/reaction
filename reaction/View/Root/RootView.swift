import SwiftUI

struct RootView: View {
    @StateObject var viewState: RootViewState

    var body: some View {
        TabView {
            ReactionListView(viewState: ReactionListViewState(
                showingThmbnail: viewState.showThmbnail)
            )
            .tabItem {
                Image(systemName: "list.dash")
                Text(String(localized: "common-list"))
            }
            SearchView(viewState: SearchViewState())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(String(localized: "common-search"))
                }
            SettingView(viewState: SettingViewState())
                .tabItem {
                    Image(systemName: "gearshape")
                    Text(String(localized: "common-setting"))
                }
        }
    }
}

#Preview {
    RootView(viewState: RootViewState())
}
