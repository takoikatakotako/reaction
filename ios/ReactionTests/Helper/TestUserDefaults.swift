import Foundation

enum TestUserDefaults {
    // テストごとに一意な suite を作り、UserDefaults.standard（アプリ本体の設定）を汚さない
    static func make(name: String = #function) -> UserDefaults {
        let suiteName = "ReactionTests.\(name).\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
