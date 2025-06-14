import SwiftUI
import Firebase
import UserNotifications
import StoreKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let userDefaultRepository = UserDefaultRepository()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        // UserDefaults
        UserDefaultRepository().initilize()
        
        // Environment
        guard let reactionsEndpoint = Bundle.main.infoDictionary?["REACTIONS_ENDPOINT"] as? String else {
            fatalError("Error: Missing RESOURCE_ENDPOINT in Info.plist")
        }
        EnvironmentVariable.shared.setReactionsEndpoint(reactionsEndpoint: reactionsEndpoint)
        
        // Push Token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }

        // 課金周りの監視
        observeTransactionUpdates()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Task {
            await updateSubscriptionStatus()
        }
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
        Messaging.messaging().apnsToken = deviceToken
    }

    // 課金
    private func observeTransactionUpdates() {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                guard case .verified(let transaction) = verificationResult else {
                    continue
                }

                if transaction.revocationDate != nil {
                    // 払い戻しされてるので特典削除
                    userDefaultRepository.setEnableDetaileAbility(false)
                } else if let expirationDate = transaction.expirationDate,
                          Date() < expirationDate // 有効期限内
                          && !transaction.isUpgraded // アップグレードされていない
                {
                    // 有効なサブスクリプションなのでproductIdに対応した特典を有効にする
                    userDefaultRepository.setEnableDetaileAbility(true)
                }

                await transaction.finish()
            }
        }
    }

    private func updateSubscriptionStatus() async {
        var validSubscription: StoreKit.Transaction?
        for await verificationResult in Transaction.currentEntitlements {
            if case .verified(let transaction) = verificationResult,
               transaction.productType == .autoRenewable && !transaction.isUpgraded {
                validSubscription = transaction
            }
        }

        if validSubscription?.productID != nil {
            // 特典を付与
            userDefaultRepository.setEnableDetaileAbility(true)
        } else {
            // 特典を削除
            userDefaultRepository.setEnableDetaileAbility(false)
        }
    }
}

 extension AppDelegate: UNUserNotificationCenterDelegate {
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

 extension AppDelegate: MessagingDelegate {}
