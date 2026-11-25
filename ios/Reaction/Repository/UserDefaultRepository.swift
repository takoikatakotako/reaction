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
    let keyDidSyncLegacyPurchase = "KEY_DID_SYNC_LEGACY_PURCHASE"
    let keyPremiumExpirationDate = "KEY_PREMIUM_EXPIRATION_DATE"

    var reactionMechanismLanguage: String {
        userDefaults.object(forKey: keyReactionMechanismLanguage) as? String ?? "en"
    }

    var showThumbnail: Bool {
        userDefaults.object(forKey: keyShowThumbnail) as? Bool ?? true
    }

    var enableDetailAbility: Bool {
        userDefaults.object(forKey: keyEnableDetailAbility) as? Bool ?? false
    }

    // 旧買い切りの購入を RevenueCat に送ったか（一度だけ送るため）
    var didSyncLegacyPurchase: Bool {
        userDefaults.bool(forKey: keyDidSyncLegacyPurchase)
    }

    // サブスクの有効期限。RevenueCat と通信できない起動時に、期限切れを判定するために使う
    var premiumExpirationDate: Date? {
        userDefaults.object(forKey: keyPremiumExpirationDate) as? Date
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

    func setDidSyncLegacyPurchase(_ didSync: Bool) {
        userDefaults.setValue(didSync, forKey: keyDidSyncLegacyPurchase)
    }

    func setPremiumExpirationDate(_ date: Date?) {
        if let date {
            userDefaults.setValue(date, forKey: keyPremiumExpirationDate)
        } else {
            userDefaults.removeObject(forKey: keyPremiumExpirationDate)
        }
    }
}
