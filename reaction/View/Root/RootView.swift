// import SwiftUI
//
// struct RootView: View {
//    var body: some View {
//        MainView()
//    }
// }
//
// #Preview {
//    RootView()
// }

import SwiftUI

struct RootView: View {
    let showThmbnail: Bool
    let selectedJapanese: Bool
    init() {
        showThmbnail = UserDefaultRepository().showThmbnail
        selectedJapanese = UserDefaultRepository().selectedJapanese
    }
    var body: some View {
        TabView {
            ReactionListView(showingThmbnail: showThmbnail, selectJapanese: selectedJapanese)
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
