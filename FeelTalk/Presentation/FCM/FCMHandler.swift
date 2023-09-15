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
        print("FCM Handeler")
        print(userInfo)
        
        guard let type: String = userInfo["type"] as? String else {
            debugPrint("fcm으로 온 데이터에 type이 적혀있지 않습니다.")
            return
        }
        
        switch type {
        case "createCouple":
            handleCoupleRegistration(userInfo)
        case "todayQuestion":
            handleTodayQusetion(userInfo)
        case "pressForAnswer":
            handlePressForAnswer(userInfo)
        case "answerQuestion":
            handleAnswerQuestion(userInfo)
        case "addChallenge":
            handleAddChallenge(userInfo)
        case "modifyChallenge":
            handelModifyChallenge(userInfo)
        case "deleteChallenge":
            handelDeleteChallenge(userInfo)
        case "completeChallenge":
            handelCompleteChallenge(userInfo)
        case "chatRoomStatusChange":
            print("앱 상태")
            
        default:
            print("fcm 타입에 매칭되는 타입이 존재하지 않습니다.")
        }
    }
    
    func handleCoupleRegistration(_ data: [AnyHashable: Any]) {
//        print(data["message"])
//        print(data["title"])
    }
    
    func handleTodayQusetion(_ data: [AnyHashable: Any]) {
        guard let title = data["title"] as? String,
              let message = data["message"] as? String,
              let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
                
        showNotification(identifier: identifier,
                         title: title,
                         body: message,
                         userInfo: ["destination": "answer",
                                    "index": index]
        )
    }
    
    func handlePressForAnswer(_ data: [AnyHashable: Any]) {
//        print(data["index"])
    }
    
    func handleAnswerQuestion(_ data: [AnyHashable: Any]) {
        guard let title = data["title"] as? String,
              let message = data["message"] as? String,
              let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
        
        showNotification(identifier: identifier,
                         title: title,
                         body: message,
                         userInfo: ["destination": "answer",
                                    "index": index]
        )
    }
    
    func handleAddChallenge(_ data: [AnyHashable: Any]) {
        guard let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
        
        print("FMC 상대방 질문 추가: \(index)")
    }
    
    func handelModifyChallenge(_ data: [AnyHashable: Any]) {
        guard let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
        
        print("FMC 상대방 질문 수정: \(index)")
    }
    
    func handelDeleteChallenge(_ data: [AnyHashable: Any]) {
        guard let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
        
        print("FMC 상대방 질문 삭제: \(index)")
    }
    
    func handelCompleteChallenge(_ data: [AnyHashable: Any]) {
        guard let index = data["index"] as? Int,
              let identifier = data["gcm.message_id"] as? String else { return }
        
        print("FMC 상대방 질문 완료: \(index)")
    }
}

extension FCMHandler {
    func showNotification(identifier: String, title: String, body: String, userInfo: [AnyHashable: Any] = [:]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current()
            .add(request) { error in
                if error != nil { print("알림 띄우기 에러: \(error!.localizedDescription)") }
            }
    }
}
