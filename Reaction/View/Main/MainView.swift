import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            StudyCategoryListView()
                .tabItem {
                    Label("学習", systemImage: "pencil.and.scribble")
                }
                .tag(1)
            
            ChatView()
                .tabItem {
                    Label("チャット", systemImage: "message")
                }
                .tag(2)
            
            ListenView()
                .tabItem {
                    Label("聴いて勉強", systemImage: "headphones")
                }
                .tag(3)
            
            SettingView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
                .tag(4)
        }
        .tint(Color(.appMain))
    }
}

#Preview {
    MainView()
}
