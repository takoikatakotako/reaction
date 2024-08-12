import SwiftUI

class SettingViewState: ObservableObject {
    @Published var langage: String = ""
    @Published var thmbnail: Bool?
    @Published var showingReactionMechanismAlert = false
    @Published var showingThmbnailAlert = false
    @Published var showingResetAlert = false

    private let userDefaultRepository = UserDefaultRepository()

    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    func onAppear() {
        let identifier = Locale.current.identifier
        if identifier.starts(with: "en") {
            langage = String(localized: "common-english")
        } else if identifier.starts(with: "ja") {
            langage = String(localized: "common-japanese")
        }

        thmbnail = userDefaultRepository.showThmbnail
    }
    
    func showReactionMechanismLanguageAlert() {
        showingReactionMechanismAlert = true
    }

    func showThumbnailAlert() {
        showingThmbnailAlert = true
    }

    func setShowThumbnail() {
        userDefaultRepository.setShowThmbnail(true)
        thmbnail = true
    }

    func setHiddenThumbnail() {
        userDefaultRepository.setShowThmbnail(false)
        thmbnail = false
    }

    func reset() {
        URLCache.shared.removeAllCachedResponses()
        showingResetAlert = true
    }
}
