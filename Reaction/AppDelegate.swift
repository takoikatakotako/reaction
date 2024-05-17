import SwiftUI
//import Firebase
//import FirebaseMessaging
//import GoogleMobileAds
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // Use Firebase library to configure APIs.
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self

        // For iOS 10 display notification (sent via APNS)
//        UNUserNotificationCenter.current().delegate = self

//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: { _, _ in }
//        )
//
//        application.registerForRemoteNotifications()

        // Admob周りの処理
//        guard let admobUnitId = Bundle.main.infoDictionary?["ADMOB_UNIT_ID"] as? String else {
//            fatalError("AdmobのUnitIdが見つかりません")
//        }
//        ADMOB_UNIT_ID = admobUnitId

//        // Initialize the Google Mobile Ads SDK.
//        GADMobileAds.sharedInstance().start(completionHandler: nil)

        UserDefaultRepository().initilize()

//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching FCM registration token: \(error)")
//            } else if let token = token {
//                print("FCM registration token: \(token)")
//                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//            }
//        }

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

    //
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // APNsより登録デバイストークンを取得し、コンソールに出力する（デバッグ用）
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print(token)
        //　メソッド実装入れ替えをしない場合、APNs発行のデバイストークンとFCM発行デバイストークンを明示的にマッピングする必要があります。
//        Messaging.messaging().apnsToken = deviceToken
    }
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        if let messageID = userInfo["gcm.message_id"] {
//            print("Message ID: \(messageID)")
//        }
//
//        print(userInfo)
//
//        completionHandler([])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        if let messageID = userInfo["gcm.message_id"] {
//            print("Message ID: \(messageID)")
//        }
//
//        print(userInfo)
//
//        completionHandler()
//    }
//}

//extension AppDelegate: MessagingDelegate {}
