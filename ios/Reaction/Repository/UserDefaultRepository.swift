import SwiftUI

class UserDefaultRepository {
    private let userDefaults: UserDefaults

    // テストでは専用の suite を渡して本番の設定を汚さないようにする
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // UserDefaults
    let KEY_REACTION_MECHANISM_LANGUAGE = "KEY_REACTION_MECHANISM_LANGUAGE"
    let KEY_SHOW_THUMBNAIL = "KEY_SHOW_THUMBNAIL"
    let KEY_ENABLE_DETAILE_ABILITY = "KEY_ENABLE_DETAILE_ABILITY"

    var reactionMechanismLanguage: String {
        userDefaults.object(forKey: KEY_REACTION_MECHANISM_LANGUAGE) as? String ?? "en"
    }

    var showThmbnail: Bool {
        userDefaults.object(forKey: KEY_SHOW_THUMBNAIL) as? Bool ?? true
    }

    var enableDetaileAbility: Bool {
        userDefaults.object(forKey: KEY_ENABLE_DETAILE_ABILITY) as? Bool ?? false
    }

    func initilize() {
        userDefaults.register(
            defaults: [
                KEY_REACTION_MECHANISM_LANGUAGE: "en",
                KEY_SHOW_THUMBNAIL: true,
                KEY_ENABLE_DETAILE_ABILITY: false
            ]
        )
    }

    func setReactionMechanismLanguage(_ language: String) {
        userDefaults.setValue(language, forKey: KEY_REACTION_MECHANISM_LANGUAGE)
    }

    func setShowThmbnail(_ showThmbnail: Bool) {
        userDefaults.setValue(showThmbnail, forKey: KEY_SHOW_THUMBNAIL)
    }

    func setEnableDetaileAbility(_ enableDetaileAbility: Bool) {
        userDefaults.setValue(enableDetaileAbility, forKey: KEY_ENABLE_DETAILE_ABILITY)
    }
}
