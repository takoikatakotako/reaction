import SwiftUI
import Firebase

@main
struct reactionApp: App {
    let showThmbnail: Bool
    let selectedJapanese: Bool
    init() {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
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
