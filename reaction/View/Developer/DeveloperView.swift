import SwiftUI

struct DeveloperView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    openUrl(urlString: "https://www.youtube.com/channel/UCdm3TnC8CqXMft7S5fIf_Jg")
                } label: {
                    DeveloperRow(imageName: "icon-sin", name: "sin有機化学")
                }
                                
                Button {
                    openUrl(urlString: "https://twitter.com/takoikatakotako")
                } label: {
                    DeveloperRow(imageName: "icon-takoika", name: "かびごん小野")
                }
                                
                Text("バージョン: \(getAppVersion())(\(getBuildVersion()))")
                    .padding(.top, 16)
                
                Spacer()
            }
            .navigationTitle("開発者")
        }
    }
    
    func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        } else {
            return ""
        }
    }
    
    func getBuildVersion() -> String {
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return buildVersion
        } else {
            return ""
        }
    }
    
    func openUrl(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
