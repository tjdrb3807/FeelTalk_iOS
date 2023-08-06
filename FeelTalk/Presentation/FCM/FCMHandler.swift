//
//  FCMHandler.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/23.
//

import Foundation
import Alamofire
import FirebaseMessaging
import UserNotifications
import RxSwift
import RxCocoa

final class FCMHandler {
    static let shared = FCMHandler()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func handle(userInfo: [AnyHashable: Any]) {
        guard let type: String = userInfo["type"] as? String else {
            debugPrint("fcm으로 온 데이터에 type이 적혀있지 않습니다.")
            return
        }
        
        switch type {
        case "createCouple":
            handleCoupleRegistration(userInfo)
        default:
            print("fcm 타입에 매칭되는 타입이 존재하지 않습니다.")
        }
    }
    
    func handleCoupleRegistration(_ data: [AnyHashable: Any]) {
        print(data["message"])
        print(data["title"])
    }
}
