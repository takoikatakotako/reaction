import SwiftUI
import Firebase

@main
struct reactionApp: App {
    init() {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ReactionListView()
        }
    }
}
