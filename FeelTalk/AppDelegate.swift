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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SNS setting
        setKakaoNativeAppKey()
        setNaverInstance()
        
        // Firebase settinf
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // UserNotification setting
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        
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
    
    /// Forground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        debugPrint("willPresent: userInfo = \(userInfo)")
        
        completionHandler([.banner, .sound, .badge])
    }
    
    /// Background / Kill or terminated
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        debugPrint("didReceive: userInfo = \(userInfo)")
    }
    
    /// Silent Push Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [AnyHashable: Any] else { return }
        
        if aps["content-available"] as? Int == 1 {
            FCMHandler.shared.handle(userInfo: userInfo)

            completionHandler(UIBackgroundFetchResult.newData)
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
