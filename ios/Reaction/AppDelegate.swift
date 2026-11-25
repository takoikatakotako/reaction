import SwiftUI
import Firebase
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let purchaseRepository = PurchaseRepository()

    // ユニットテスト実行時（XCTest がホストアプリとして起動したとき）は true
    private var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // UserDefaults
        UserDefaultRepository().initialize()

        // Environment
        guard let reactionsEndpoint = Bundle.main.infoDictionary?["REACTIONS_ENDPOINT"] as? String else {
            fatalError("Error: Missing RESOURCE_ENDPOINT in Info.plist")
        }
        EnvironmentVariable.shared.setReactionsEndpoint(reactionsEndpoint)

        guard let questionsEndpoint = Bundle.main.infoDictionary?["QUESTIONS_ENDPOINT"] as? String else {
            fatalError("Error: Missing QUESTIONS_ENDPOINT in Info.plist")
        }
        EnvironmentVariable.shared.setQuestionsEndpoint(questionsEndpoint)

        guard let noticesEndpoint = Bundle.main.infoDictionary?["NOTICES_ENDPOINT"] as? String else {
            fatalError("Error: Missing NOTICES_ENDPOINT in Info.plist")
        }
        EnvironmentVariable.shared.setNoticesEndpoint(noticesEndpoint)

        // ユニットテスト中は Firebase・通知・課金の初期化を行わない（CI のシミュレータで落ちるため）
        if isRunningUnitTests {
            return true
        }

        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        // 課金（RevenueCat）。特典フラグは RevenueCat の状態が変わるたびに更新する
        guard let revenueCatApiKey = Bundle.main.infoDictionary?["REVENUECAT_API_KEY"] as? String,
              !revenueCatApiKey.isEmpty else {
            fatalError("Error: Missing REVENUECAT_API_KEY in Info.plist")
        }
        PurchaseRepository.configure(apiKey: revenueCatApiKey)
        Task { [purchaseRepository] in
            await purchaseRepository.observeCustomerInfo()
        }

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
        Messaging.messaging().apnsToken = deviceToken
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
