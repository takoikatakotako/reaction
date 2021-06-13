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
                    Text("List")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Tag")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "3.square.fill")
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
