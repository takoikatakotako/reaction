import SwiftUI

struct DeveloperView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    openUrl(urlString: "https://www.youtube.com/channel/UCdm3TnC8CqXMft7S5fIf_Jg")
                } label: {
                    DeveloperRow(imageName: R.image.iconSin.name, role: String(localized: "developer-general-manager"), name: "sin有機化学")
                        .padding(.horizontal, 8)
                }

                Divider()

                Button {
                    openUrl(urlString: "https://twitter.com/takoikatakotako")
                } label: {
                    DeveloperRow(imageName: R.image.iconTakoika.name, role: String(localized: "developer-programmer"), name: "かびごん小野")
                        .padding(.horizontal, 8)
                }

                Divider()

                Spacer()
            }
            .navigationTitle(String(localized: "developer-title"))
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
