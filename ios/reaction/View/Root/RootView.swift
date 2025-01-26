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
                CommonText(text: String(localized: "common-list"), font: Font.system(size: 12))
            }
            SearchView(viewState: SearchViewState())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    CommonText(text: String(localized: "common-search"), font: Font.system(size: 12))
                }
            QuestionListView(viewState: QuestionViewState())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    CommonText(text: String(localized: "common-search"), font: Font.system(size: 12))
                }
            SettingView(viewState: SettingViewState())
                .tabItem {
                    Image(systemName: "gearshape")
                    CommonText(text: String(localized: "common-setting"), font: Font.system(size: 12))
                }
        }
        .tint(Color(.appMainText))
    }
}

#Preview {
    RootView(viewState: RootViewState())
}
