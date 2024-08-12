import SwiftUI

class SettingViewState: ObservableObject {
    @Published var reactionMechanismLangage: String = ""
    @Published var appLangage: String = ""
    @Published var thmbnail: Bool?
    @Published var showingReactionMechanismAlert = false
    @Published var showingThmbnailAlert = false
    @Published var showingResetAlert = false

    private let userDefaultRepository = UserDefaultRepository()

    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    func onAppear() {
        // 反応機構の言語
        let reactionMechanismLanguage = userDefaultRepository.reactionMechanismLanguage
        setReactionMechanismLanguage(language: reactionMechanismLanguage)
        
        // アプリの言語
        let appLangageidentifier = Locale.current.identifier
        if appLangageidentifier.starts(with: "en") {
            appLangage = String(localized: "common-english")
        } else if appLangageidentifier.starts(with: "ja") {
            appLangage = String(localized: "common-japanese")
        }

        thmbnail = userDefaultRepository.showThmbnail
    }
    
    func showReactionMechanismLanguageAlert() {
        showingReactionMechanismAlert = true
    }

    func showThumbnailAlert() {
        showingThmbnailAlert = true
    }
    
    func updateReactionMechanismLanguage(language: String) {
        // 反応機構の言語を更新
        userDefaultRepository.setReactionMechanismLanguage(language)
        setReactionMechanismLanguage(language: language)
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
    
    
    private func setReactionMechanismLanguage(language: String) {
        // 反応機構の言語を更新
        if language.starts(with: "en") {
            self.reactionMechanismLangage = String(localized: "common-english")
        } else if language.starts(with: "ja") {
            self.reactionMechanismLangage = String(localized: "common-japanese")
        }
    }
}
