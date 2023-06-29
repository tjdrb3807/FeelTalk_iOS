//
//  AppDelegate.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/07.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Kakao
        let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey as! String)
        
        // FirebaseMessaging: Firebase Core 설정 및 Messaging Delegate 추가
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
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
    
    
    
    // Device Token을 APNs에 알려주기
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Kakao
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }
    

    func registerForPushNotifications() {
        // 1 - UNUserNotificationCenter는 푸시 알림을 포함하여 앱의 모든 알림 관련 활동을 처리합니다.
        UNUserNotificationCenter.current()
        // 2 -알림을 표시하기 위한 승인을 요청합니다. 전달된 옵션은 앱에서 사용하려는 알림 유형을 나타냅니다. 여기에서 알림(alert), 소리(sound) 및 배지(badge)를 요청합니다.
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                // 3 - 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                
                self.getNotificationSettings()
            }
        
        
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // TODO: - Device Token을 발급받은 이후 서버에 전달하는 작업 구현
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FirebaseMessaging")
        let deviceToken: [String: String] = ["token" : fcmToken ?? ""]
        print("Device token: ", deviceToken)
    }
}

