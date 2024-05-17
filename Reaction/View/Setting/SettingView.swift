import SwiftUI
import LicenseList

struct SettingView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("問題設定") {
                    NavigationLink {
                        Text("SDF")
                    } label: {
                        Text("問題カテゴリー")
                            .foregroundStyle(Color(.appMainText))
                    }
                }
                
                Section("ユーザー情報") {
                    NavigationLink {
                        
                    } label: {
                        Text("ユーザー情報")
                            .foregroundStyle(Color(.appMainText))
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Text("プレミアムプランについて")
                    }
                }
                
                Section("お問い合わせ") {
                    NavigationLink {
                        
                    } label: {
                        Text("お問い合わせ")
                    }
                }
                
                Section("開発者情報") {
                    Button {
                        
                    } label: {
                        Text("公式Discord")
                            .foregroundStyle(Color(.appMainText))
                    }

                    Button {
                        
                    } label: {
                        Text("開発者のXアカウント")
                            .foregroundStyle(Color(.appMainText))
                    }
                }
                
                
                Section("アプリケーション情報") {
                    HStack {
                        Text("バージョン情報")
                        Spacer()
                        Text("1.0.0(3)")
                    }
                    NavigationLink {
                        LicenseListView()
                    } label: {
                        Text("ライセンス")
                    }
                }
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("設定")
                        .font(.system(size: 16).bold())
                        .foregroundStyle(Color.white)
                }
            }
            .toolbarBackground(Color(.appMain),for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}


#Preview {
    SettingView()
}
