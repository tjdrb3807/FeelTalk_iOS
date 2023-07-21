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
        
//        print(KeychainRepository.getItem(key: "accessToken"))
//        print(KeychainRepository.getItem(key: "refreshToken"))
        
//        _ = KeychainRepository.deleteItem(key: "accessToken")
//        _ = KeychainRepository.deleteItem(key: "refreshToken")
//        _ = KeychainRepository.deleteItem(key: "fcmToken")
        
        // SNS
        setKakaoNativeAppKey()
        setNaverInstance()
        
        // FCM
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // APNs
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
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        // Naver
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        // Naver는 return true
        
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

// MARK: APNs
extension AppDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
            
                guard granted else { return }
                self.getNotificationSetting()
            }
    }
    
    func getNotificationSetting() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // TODO: 토큰을 keychain에 저장하고 SignUp API 메서드에서 서버로 전달하는 로직
    /// registerForRemoteNotifications() 가 성골할 떄마다 iOS에서 호출
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// registerForRemoteNotifications()가 실패하면 iOS에서 호출
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
}

// MARK: FCM
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FirebaseMessaging")
        guard let fcmToken = fcmToken else { return }
        guard KeychainRepository.addItem(value: fcmToken, key: "fcmToken") else { return }
        let deviceToken: [String: String] = ["token": fcmToken]
        print("Device token: ", deviceToken)
    }
}

