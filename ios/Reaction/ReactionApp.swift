import SwiftUI
import UserNotifications

@main
struct ReactionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(viewState: RootViewState())
        }
    }
}
