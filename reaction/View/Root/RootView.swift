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
                    Image(systemName: "1.square.fill")
                    Text("いちらん")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("けんさく")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("設定")
                }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
