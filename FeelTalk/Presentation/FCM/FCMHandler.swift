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
    
    let partnerSignalObservable = PublishRelay<Signal>()
    let partnerChatRoomStatusObserver = PublishRelay<Bool>()
    
    func handle(userInfo: [AnyHashable: Any]) {
        guard let type: String = userInfo["type"] as? String else {
            debugPrint("fcm으로 온 데이터에 type이 적혀있지 않습니다.")
            return
        }
        
        switch type {
        case "signalChatting":
            handleSignalChatting(userInfo)
        case "chatRoomStatusChange":
            print(userInfo)
        case "pressForAnswerChatting":
            handlePressForAnswerChatting(userInfo)
            
        default:
            print("fcm 타입에 매칭되는 타입이 존재하지 않습니다.")
        }
    }
}

// MARK: Chat
extension FCMHandler {
    func handlePartnerChatRoomStatus(_ data: [AnyHashable: Any]) {
        guard let status = data["isInChat"] as? Bool else { return }
        
        partnerChatRoomStatusObserver.accept(status)
    }
}

// MARK: Couple
extension FCMHandler {
    
}

// MARK: Question
extension FCMHandler {
    func handlePressForAnswerChatting(_ data: [AnyHashable: Any]) {
        guard let chatIndexStr = data["index"] as? String,
              let chatPageIndexStr = data["pageIndex"] as? String,
              let chatIsReadStr = data["isRead"] as? String,
              let questionIndexStr = data["coupleQuestion"] as? String,
        let identifier = data["gcm.message_id"] as? String else { return }
        
        print(chatIndexStr)
        print(chatPageIndexStr)
        print(chatIsReadStr)
        print(questionIndexStr)
        
        showNotification(identifier: identifier,
                         title: "쿡쿡👉👉답장해줘!😑",
                         body: "오늘의 질문에 답변을 남겨주세요!")
        
    }
}

// MARK: Signal
extension FCMHandler {
    func handleSignalChatting(_ data: [AnyHashable: Any]) {
        guard let signalTypeStr = data["signal"] as? String,
              let pageIndexStr = data["pageIndex"] as? String,
              let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let signalType = mappingSignalType(signalTypeStr),
              let pageIndex = Int(pageIndexStr),
              let index = Int(indexStr) else { return }
        
        print(isReadStr)
        print(createAtStr)
        print(pageIndex)
        print(index)
        
        partnerSignalObservable.accept(Signal(type: signalType))
        
        showNotification(identifier: identifier,
                         title: "오늘 내 시그널은 말야!💋",
                         body: "OOO님이 은밀한 시그널을 보냈어요!")
    }
    
    func mappingSignalType(_ str: String) -> SignalType? {
        switch str {
        case "100":
            return SignalType.sexy
        case "75":
            return SignalType.love
        case "50":
            return SignalType.ambiguous
        case "25":
            return SignalType.refuse
        case "0":
            return SignalType.tired
        default:
            break
        }
        
        return nil
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
