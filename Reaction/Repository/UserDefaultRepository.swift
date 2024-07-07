import SwiftUI

class UserDefaultRepository {
    // UserDefaults
    let KEY_SHOW_THUMBNAIL = "KEY_SHOW_THUMBNAIL"
    let KEY_SELECTED_JAPANESE = "KEY_SELECTED_JAPANESE"
    let KEY_ENABLE_DETAILE_ABILITY = "KEY_ENABLE_DETAILE_ABILITY"

    var showThmbnail: Bool {
        UserDefaults.standard.object(forKey: KEY_SHOW_THUMBNAIL) as? Bool ?? true
    }

    var selectedJapanese: Bool {
        UserDefaults.standard.object(forKey: KEY_SELECTED_JAPANESE) as? Bool ?? false
    }

    var enableDetaileAbility: Bool {
        UserDefaults.standard.object(forKey: KEY_ENABLE_DETAILE_ABILITY) as? Bool ?? false
    }

    func initilize() {
        UserDefaults.standard.register(
            defaults: [
                KEY_SHOW_THUMBNAIL: true,
                KEY_SELECTED_JAPANESE: false,
                KEY_ENABLE_DETAILE_ABILITY: false
            ]
        )
    }

    func setShowThmbnail(_ showThmbnail: Bool) {
        UserDefaults.standard.setValue(showThmbnail, forKey: KEY_SHOW_THUMBNAIL)
    }

    func setSelectedJapanese(_ selectedJapanese: Bool) {
        UserDefaults.standard.setValue(selectedJapanese, forKey: KEY_SELECTED_JAPANESE)
    }

    func setEnableDetaileAbility(_ enableDetaileAbility: Bool) {
        UserDefaults.standard.setValue(enableDetaileAbility, forKey: KEY_ENABLE_DETAILE_ABILITY)
    }
}
