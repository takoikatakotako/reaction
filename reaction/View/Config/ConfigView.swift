import SwiftUI

struct ConfigView: View {
    @State var langage: String = ""
    @State var thmbnail: Bool?
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: ConfigLangageView()) {
                    HStack {
                        Text("Language")
                            .padding(8)
                        Spacer()
                        Text(langage)
                            .padding(.trailing, 8)
                    }
                    .frame(height: 44)
                }
                Divider()
                NavigationLink(destination: ConfigThmbnailView()) {
                    HStack {
                        Text("Thmbnail")
                            .padding(8)
                        Spacer()
                        if let thmbnail = thmbnail {
                            Text(thmbnail ? "Show" : "Hidden")
                                .padding(.trailing, 8)
                        }
                    }
                    .frame(height: 44)
                }
                Divider()
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
                    .frame(height: 44)
                })
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
