import SwiftUI

@MainActor
final class SettingViewState: ObservableObject {
    @Published var reactionMechanismLanguageText: String = ""
    @Published var appLanguage: String = ""
    @Published var thumbnail: Bool?
    @Published var showingReactionMechanismAlert = false
    @Published var showingThumbnailAlert = false

    private let userDefaultRepository = UserDefaultRepository()

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return "\(version) (\(build))"
    }

    /// 例: "iPhone17,3 / iOS 26.1"
    var deviceDescription: String {
        "\(Self.modelIdentifier) / \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }

    var contactFormURL: URL? {
        Config.contactFormURL(device: deviceDescription, appVersion: appVersion)
    }

    private static var modelIdentifier: String {
        if let simulatorModel = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModel
        }
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafeBytes(of: &systemInfo.machine) { buffer in
            String(bytes: buffer.prefix(while: { $0 != 0 }), encoding: .utf8) ?? ""
        }
    }

    func onAppear() {
        // 反応機構の言語
        let reactionMechanismLanguage = userDefaultRepository.reactionMechanismLanguage
        setReactionMechanismLanguage(language: reactionMechanismLanguage)

        // アプリの言語
        let appLanguageIdentifier = Locale.current.identifier
        if appLanguageIdentifier.starts(with: "en") {
            appLanguage = String(localized: "common-english")
        } else if appLanguageIdentifier.starts(with: "ja") {
            appLanguage = String(localized: "common-japanese")
        }

        thumbnail = userDefaultRepository.showThumbnail
    }

    func showReactionMechanismLanguageAlert() {
        showingReactionMechanismAlert = true
    }

    func showThumbnailAlert() {
        showingThumbnailAlert = true
    }

    func updateReactionMechanismLanguage(language: String) {
        // 反応機構の言語を更新
        userDefaultRepository.setReactionMechanismLanguage(language)
        setReactionMechanismLanguage(language: language)
    }

    func setShowThumbnail() {
        userDefaultRepository.setShowThumbnail(true)
        thumbnail = true
    }

    func setHiddenThumbnail() {
        userDefaultRepository.setShowThumbnail(false)
        thumbnail = false
    }

    private func setReactionMechanismLanguage(language: String) {
        // 反応機構の言語を更新
        if language.starts(with: "en") {
            self.reactionMechanismLanguageText = String(localized: "common-english")
        } else if language.starts(with: "ja") {
            self.reactionMechanismLanguageText = String(localized: "common-japanese")
        }
    }
}
