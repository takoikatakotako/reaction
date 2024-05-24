import SwiftUI

struct ConfigView: View {
    @State var langage: String = ""
    @State var thmbnail: Bool?
    
    @StateObject var viewState: ConfigViewState
    
    var body: some View {
        NavigationStack {
            List {
                
                
                Section("App Setting") {
                    NavigationLink(destination: ConfigLangageView()) {
                        HStack {
                            Text("Language")
                            Spacer()
                            Text(langage)
                        }
                    }
                    
                    NavigationLink(destination: ConfigThmbnailView()) {
                        HStack {
                            Text("Thmbnail")
                            Spacer()
                            if let thmbnail = thmbnail {
                                Text(thmbnail ? "Show" : "Hidden")
                            }
                        }
                    }
                }
                
                
                Button(action: {
                    if let url = URL(string: GITHUB_REPOSITORY_URL) {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    HStack {
                        Text("GitHub")
                            .padding(8)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .padding(.trailing, 8)
                    }
                })
                
                
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
                        // LicenseListView()
                        Text("XXX")
                    } label: {
                        Text("ライセンス")
                    }
                }
                
                Section("キャッシュ削除") {
                    NavigationLink {
                        // LicenseListView()
                        Text("XXX")
                    } label: {
                        Text("ライセンス")
                    }
                }
                
            }
            .onAppear {
                let userDefaultRepository = UserDefaultRepository()
                if userDefaultRepository.selectedJapanese {
                    langage = "Japanese"
                } else {
                    langage = "English"
                }

                if userDefaultRepository.showThmbnail {
                    thmbnail = true
                } else {
                    thmbnail = false
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Config")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    ConfigView(viewState: ConfigViewState())
}
