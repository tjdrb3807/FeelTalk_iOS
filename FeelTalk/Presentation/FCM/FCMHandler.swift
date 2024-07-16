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
    
    let createCoupleObservable = PublishRelay<Bool>()
    let partnerSignalObservable = PublishRelay<Signal>()
    let partnerChatRoomStatusObserver = PublishRelay<Bool>()
    
    func handle(userInfo: [AnyHashable: Any]) {
        print("received fcm: \(userInfo)")
        
        guard let type: String = userInfo["type"] as? String else {
            debugPrint("fcm으로 온 데이터에 type이 적혀있지 않습니다.")
            return
        }
        
        // MARK: 나중에 handler들에서 질문과 챌린지를 불러올 때 사용할 것
//        let questionUseCase = DefaultQuestionUseCase(
//            questionRepository: DefaultQuestionRepository(),
//            userRepository: DefaultUserRepository())
//        let challengeUseCase = DefaultChallengeUseCase(
//            challengeRepository: DefaultChallengeRepository())
        
        switch type {
        case "createCouple":
            handleCreateCouple(userInfo)
        case "todayQuestion":
            handleTodayQuestion(userInfo)
        case "questionChatting":
            handleQuestionChatting(userInfo)
        case "answerChatting":
            handleAnswerChatting(userInfo)
        case "addChallengeChatting":
            handleAddChallenge(userInfo)
        case "completeChallengeChatting":
            handleCompleteChallenge(userInfo)
        case "deleteChallenge":
            handleDeleteChallenge(userInfo)
        case "modifyChallenge":
            handleDeleteChallenge(userInfo)
            
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
    func handleCreateCouple(_ data: [AnyHashable: Any]) {
        let title = data["title"] as? String ?? "연인 등록을 완료했어요"
        createCoupleObservable.accept(true)
        showNotification(identifier: title,
                         title: title,
                         body: data["message"] as? String ?? "앱에 들어와서 확인해보세요")
    }
}

// MARK: Question
extension FCMHandler {
    func handleTodayQuestion(_ data: [AnyHashable: Any]) {
        guard let title = data["title"] as? String else { return }
        guard let message = data["message"] as? String else { return }
        guard let index  = data["index"] as? String else { return }
        
        showNotification(identifier: index,
                         title: title,
                         body: message)
    }
    
    func handleQuestionChatting(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
        guard let pageIndex  = data["pageIndex"] as? Int else { return }
        guard let isRead  = data["isRead"] as? Bool else { return }
        guard let createAt  = data["createAt"] as? String else { return }
        guard let coupleQuestionJson  = data["coupleQuestion"] as? String else { return }
//        guard let questionIndex  = data[""] as? Int else { return }
        
        showNotification(identifier: index,
                         title: "연인 모두 질문에 답변했어요",
                         body: "앱에 들어와서 확인해보세요")
    }
    
    func handleAnswerChatting(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
        guard let pageIndex  = data["pageIndex"] as? Int else { return }
        guard let isRead  = data["isRead"] as? Bool else { return }
        guard let createAt  = data["createAt"] as? String else { return }
        guard let coupleQuestionJson  = data["coupleQuestion"] as? String else { return }
//        guard let questionIndex  = data[""] as? Int else { return }
        
        showNotification(identifier: index,
                         title: "연인이 질문에 답변을 했어요",
                         body: "앱에 들어와서 확인해보세요")
    }
    
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

// MARK: Challenge
extension FCMHandler {
    func handleAddChallenge(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
        guard let pageIndex  = data["pageIndex"] as? Int else { return }
        guard let isRead  = data["isRead"] as? Bool else { return }
        guard let createAt  = data["createAt"] as? String else { return }
        guard let coupleChallengeJson  = data["coupleChallenge"] as? String
        else { return }
//        guard let challengeIndex  = data[""] as? Int else { return }
        
        showNotification(identifier: index,
                         title: "연인이 챌린지를 추가했어요",
                         body: "앱에 들어와서 확인해보세요")
    }
    
    func handleCompleteChallenge(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
        guard let pageIndex  = data["pageIndex"] as? Int else { return }
        guard let isRead  = data["isRead"] as? Bool else { return }
        guard let createAt  = data["createAt"] as? String else { return }
        guard let coupleChallengeJson  = data["coupleChallenge"] as? String
        else { return }
//        guard let challengeIndex  = data[""] as? Int else { return }
        
        showNotification(identifier: index,
                         title: "연인이 챌린지를 완료했어요",
                         body: "앱에 들어와서 확인해보세요")
    }
    
    func handleDeleteChallenge(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
    }
    
    func handleModifyChallenge(_ data: [AnyHashable: Any]) {
        guard let index  = data["index"] as? String else { return }
        let title  = data["title"] as? String ?? "연인이 챌린지를 수정했어요"
        let message  = data["message"] as? String ?? "앱에 들어와서 확인해보세요"
        
        showNotification(identifier: index,
                         title: title,
                         body: message)
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
