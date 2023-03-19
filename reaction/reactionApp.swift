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


class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        
        
        // Admob周りの処理
        guard let admobUnitId = Bundle.main.infoDictionary?["ADMOB_UNIT_ID"] as? String else {
            fatalError("AdmobのUnitIdが見つかりません")
        }
        ADMOB_UNIT_ID = admobUnitId
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        UserDefaultRepository().initilize()

        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         // Called when a new scene session is being created.
         // Use this method to select a configuration to create the new scene with.
         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
     }

     func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         // Called when the user discards a scene session.
         // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
         // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
     }

     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
         // Print message ID.
         if let messageID = userInfo["gcm.message_id"] {
             print("Message ID: \(messageID)")
         }

         // Print full message.
         print(userInfo)
     }

     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         // Print message ID.
         if let messageID = userInfo["gcm.message_id"] {
             print("Message ID: \(messageID)")
         }

         // Print full message.
         print(userInfo)

         completionHandler(UIBackgroundFetchResult.newData)
     }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       let userInfo = notification.request.content.userInfo

       if let messageID = userInfo["gcm.message_id"] {
           print("Message ID: \(messageID)")
       }

       print(userInfo)

       completionHandler([])
   }

   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
       let userInfo = response.notification.request.content.userInfo
       if let messageID = userInfo["gcm.message_id"] {
           print("Message ID: \(messageID)")
       }

       print(userInfo)

       completionHandler()
   }
}
