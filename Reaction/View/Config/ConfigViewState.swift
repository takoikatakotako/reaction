import SwiftUI

class ConfigViewState: ObservableObject {
    @Published var langage: String = ""
    @Published var thmbnail: Bool?
    @Published var showingAlert = false

    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    func onAppear() {
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

    func reset() {
        URLCache.shared.removeAllCachedResponses()
        showingAlert = true
    }
}
