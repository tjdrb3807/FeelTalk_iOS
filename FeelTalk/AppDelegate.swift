//
//  AppDelegate.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import GoogleSignIn
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SNS setting
        setKakaoNativeAppKey()
        setNaverInstance()
        
        // Firebase setting
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = false
        
        print("fcmToken: \(Messaging.messaging().fcmToken ?? "")")
        // cRBB7cbPmki6nfs82_jZiE:APA91bGN_JrO__4sV2VT9D9wqeZZ0FW1m0YG-3YQOGmLYyUuA7U9QqCtpvqtg0NDsm1gpg-033EsBzaCUfydl7eJY74bC3GZyRk2VYh77unM_6OlEppQl8NB-Ogl5JwgqcI4TahEtfLY
        
        // UserNotification setting
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
//        application.registerForRemoteNotifications()
        
        // mixpanel setting
        Mixpanel.initialize(
            token: Bundle.main.infoDictionary?["MixpanelToken"] as? String ?? "",
            trackAutomaticEvents: true)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Kakao
        if (AuthApi.isKakaoTalkLoginUrl(url)) { return AuthController.handleOpenUrl(url: url) }
        
        // Naver
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        
        // Google
        if GIDSignIn.sharedInstance.handle(url) { return true }
        
        return false
    }
}

// MARK: SNS login
extension AppDelegate {
    func setKakaoNativeAppKey() {
        let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey as! String)
    }
    
    func setNaverInstance() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
    }
}

// MARK: UserNoticicaiton
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else { return }
                self.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    // APNs 등록
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
    }
    
    /// registerForRemoteNotifications()가 성공할 떄마다 호출
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// registerForRemoteNotifications()가 실패하면 호출
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
        
    /// 앱이 포그라운드인 상태에서 fcm 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        completionHandler([.banner, .sound, .badge])
    }
        
    
    // 백그라운드와 포그라운드의 푸시 메시지를 받고 클릭했을 때 응답 처리
    /// Background / Kill or terminated
    /// https://eunjin3786.tistory.com/379
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        let identifier = response.notification.request.identifier
        
        completionHandler()
    }

    /// 백그라운드 작업 자동 처리 (content_available가 true인 fcm이 도착 했을 때)
    /// Silent Push Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

//        print("")
//        print("=============================================")
//        print("[AppDelegate >> didReceiveRemoteNotification]")
//        print("---------------------------------------------")
//        print("설명 :: 리모트 푸시 알림 확인")
//        print("---------------------------------------------")
//        print("applicationState :: \(String(describing: UIApplication.shared.applicationState))")
//        print("=============================================")
//
//        switch UIApplication.shared.applicationState {
//        case .active:
//            print("")
//            print("=============================================")
//            print("[AppDelegate >> didReceiveRemoteNotification]")
//            print("---------------------------------------------")
//            print("설명 :: 포그라운드 상태에서 푸시알림 전달받음")
//            print("---------------------------------------------")
//            print("userInfo :: \(userInfo.description)")
//            print("=============================================")
//            print("")
//        case .inactive:
//            print("")
//            print("=============================================")
//            print("[AppDelegate >> didReceiveRemoteNotification]")
//            print("---------------------------------------------")
//            print("설명 :: 푸시 클릭 접속 확인")
//            print("---------------------------------------------")
//            print("userInfo :: \(userInfo.description)")
//            print("=============================================")
//            print("")
//        case .background:
//            print("")
//            print("=============================================")
//            print("[AppDelegate >> didReceiveRemoteNotification]")
//            print("---------------------------------------------")
//            print("설명 :: 백그라운드 상태에서 푸시알림 전달받음")
//            print("---------------------------------------------")
//            print("userInfo :: \(userInfo.description)")
//            print("=============================================")
//            print("")
//        @unknown default:
//            print("")
//            print("=============================================")
//            print("[AppDelegate >> didReceiveRemoteNotification]")
//            print("---------------------------------------------")
//            print("설명 :: default")
//            print("=============================================")
//            print("")
//            break
//        }


        guard let aps = userInfo["aps"] as? [AnyHashable: Any] else {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }

        if aps["content-available"] as? Int == 1 {
            let isBackground = UIApplication.shared.applicationState != .active
            FCMHandler.shared.handle(userInfo: userInfo, isBackground: isBackground)
            completionHandler(UIBackgroundFetchResult.newData)
            return
        }

        completionHandler(UIBackgroundFetchResult.noData)
    }
}

// MARK: FCM
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        guard KeychainRepository.addItem(value: fcmToken, key: "fcmToken") else { return }
        print("FCM Token: \(fcmToken)")
    }
}
