import SwiftUI

struct ConfigView: View {
    @State var langage: String = ""
    @State var thmbnail: Bool?
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: ConfigLangageView()) {
                    HStack {
                        Text("反応機構の言語")
                            .padding(8)
                        Spacer()
                        Text(langage)
                            .padding(.trailing, 8)
                    }
                }
                Divider()
                NavigationLink(destination: ConfigThmbnailView()) {
                    HStack {
                        Text("サムネイル")
                            .padding(8)
                        Spacer()
                        if let thmbnail = thmbnail {
                            Text(thmbnail ? "表示" : "非表示")
                                .padding(.trailing, 8)
                        }
                    }
                }
                Divider()
                Spacer()
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
            .navigationTitle("Config")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
