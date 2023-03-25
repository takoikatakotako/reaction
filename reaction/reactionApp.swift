import SwiftUI
import Firebase
import FirebaseMessaging
import GoogleMobileAds
import UserNotifications

@main
struct reactionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}


