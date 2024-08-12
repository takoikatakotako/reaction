import SwiftUI

class UserDefaultRepository {
    // UserDefaults
    let KEY_REACTION_MECHANISM_LANGUAGE = "KEY_REACTION_MECHANISM_LANGUAGE"
    let KEY_SHOW_THUMBNAIL = "KEY_SHOW_THUMBNAIL"
    let KEY_ENABLE_DETAILE_ABILITY = "KEY_ENABLE_DETAILE_ABILITY"

    var reactionMechanismLanguage: String {
        UserDefaults.standard.object(forKey: KEY_REACTION_MECHANISM_LANGUAGE) as? String ?? "en"
    }
    
    var showThmbnail: Bool {
        UserDefaults.standard.object(forKey: KEY_SHOW_THUMBNAIL) as? Bool ?? true
    }

    var enableDetaileAbility: Bool {
        UserDefaults.standard.object(forKey: KEY_ENABLE_DETAILE_ABILITY) as? Bool ?? false
    }

    func initilize() {
        UserDefaults.standard.register(
            defaults: [
                KEY_REACTION_MECHANISM_LANGUAGE: "en",
                KEY_SHOW_THUMBNAIL: true,
                KEY_ENABLE_DETAILE_ABILITY: false
            ]
        )
    }

    func setReactionMechanismLanguage(_ language: String) {
        UserDefaults.standard.setValue(language, forKey: KEY_REACTION_MECHANISM_LANGUAGE)
    }
    
    func setShowThmbnail(_ showThmbnail: Bool) {
        UserDefaults.standard.setValue(showThmbnail, forKey: KEY_SHOW_THUMBNAIL)
    }

    func setEnableDetaileAbility(_ enableDetaileAbility: Bool) {
        UserDefaults.standard.setValue(enableDetaileAbility, forKey: KEY_ENABLE_DETAILE_ABILITY)
    }
}
