import SwiftUI
import Firebase

@main
struct reactionApp: App {
    let showThmbnail: Bool
    let selectedJapanese: Bool
    init() {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        // Admob周りの処理
        guard let admobUnitId = Bundle.main.infoDictionary?["ADMOB_UNIT_ID"] as? String else {
            fatalError("AdmobのUnitIdが見つかりません")
        }
        ADMOB_UNIT_ID = admobUnitId
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        UserDefaultRepository().initilize()
        
        showThmbnail = UserDefaultRepository().showThmbnail
        selectedJapanese = UserDefaultRepository().selectedJapanese
    }
    var body: some Scene {
        WindowGroup {
            ReactionListView(showingThmbnail: showThmbnail, selectJapanese: selectedJapanese)
        }
    }
}
