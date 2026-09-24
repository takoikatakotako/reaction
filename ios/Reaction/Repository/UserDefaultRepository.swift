import SwiftUI

final class UserDefaultRepository {
    private let userDefaults: UserDefaults

    // テストでは専用の suite を渡して本番の設定を汚さないようにする
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // UserDefaults
    // 保存キーの文字列は既存ユーザーの設定を引き継ぐため変更しない
    let keyReactionMechanismLanguage = "KEY_REACTION_MECHANISM_LANGUAGE"
    let keyShowThumbnail = "KEY_SHOW_THUMBNAIL"
    let keyEnableDetailAbility = "KEY_ENABLE_DETAILE_ABILITY"

    var reactionMechanismLanguage: String {
        userDefaults.object(forKey: keyReactionMechanismLanguage) as? String ?? "en"
    }

    var showThumbnail: Bool {
        userDefaults.object(forKey: keyShowThumbnail) as? Bool ?? true
    }

    var enableDetailAbility: Bool {
        userDefaults.object(forKey: keyEnableDetailAbility) as? Bool ?? false
    }

    func initialize() {
        userDefaults.register(
            defaults: [
                keyReactionMechanismLanguage: "en",
                keyShowThumbnail: true,
                keyEnableDetailAbility: false
            ]
        )
    }

    func setReactionMechanismLanguage(_ language: String) {
        userDefaults.setValue(language, forKey: keyReactionMechanismLanguage)
    }

    func setShowThumbnail(_ showThumbnail: Bool) {
        userDefaults.setValue(showThumbnail, forKey: keyShowThumbnail)
    }

    func setEnableDetailAbility(_ enableDetailAbility: Bool) {
        userDefaults.setValue(enableDetailAbility, forKey: keyEnableDetailAbility)
    }
}
