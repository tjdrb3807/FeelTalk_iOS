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
    
    let partnerChatRoomStatusObservable = PublishRelay<Bool>()
    
    let createCoupleObservable = PublishRelay<Bool>()
    let chatObservable = PublishRelay<Chat>()
    let meIsInChatObsesrvable = BehaviorRelay<Bool>(value: false)
    
    private let CHATTNING_NOTIFICATION_ID = "CHATTNING_NOTIFICATION_ID"
    
    
    private let questionUseCase = DefaultQuestionUseCase(
        questionRepository: DefaultQuestionRepository(),
        userRepository: DefaultUserRepository()
    )
    private let challengeUseCase = DefaultChallengeUseCase(
        challengeRepository: DefaultChallengeRepository()
    )
    
    func handle(userInfo: [AnyHashable: Any], isBackground: Bool) {
        print("received fcm: \(userInfo)")
        
        guard let type: String = userInfo["type"] as? String else {
            debugPrint("fcm으로 온 데이터에 type이 적혀있지 않습니다.")
            return
        }
        
        switch type {
        case "createCouple":
            handleCreateCouple(userInfo, isBackground)
        case "chatRoomStatusChange":
            handlePartnerChatRoomStatus(userInfo, isBackground)
        case "textChatting":
            handleTextChatting(userInfo, isBackground)
        case "voiceChatting":
            handleVoiceChatting(userInfo, isBackground)
        case "imageChatting":
            handleImageChatting(userInfo, isBackground)
        case "signalChatting":
            handleSignalChatting(userInfo, isBackground)
        case "questionChatting":
            handleQuestionChatting(userInfo, isBackground)
        case "answerChatting":
            handleAnswerChatting(userInfo, isBackground)
        case "challengeChatting":
            handleChallenge(userInfo, isBackground)
        case "addChallengeChatting":
            handleAddChallenge(userInfo, isBackground)
        case "completeChallengeChatting":
            handleCompleteChallenge(userInfo, isBackground)
        case "resetPartnerPasswordChatting":
            handleResetPartnerPasswordChatting(userInfo, isBackground)
        case "todayQuestion":
            handleTodayQuestion(userInfo, isBackground)
        case "pressForAnswerChatting":
            handlePressForAnswerChatting(userInfo, isBackground)
        case "answerQuestion":
            handleAnswerQuestionChatting(userInfo, isBackground)
        case "deleteChallenge":
            handleDeleteChallenge(userInfo, isBackground)
        case "modifyChallenge":
            handleModifyChallenge(userInfo, isBackground)
        default:
            print("fcm 타입에 매칭되는 타입이 존재하지 않습니다.")
        }
    }
}

// MARK: Chat
extension FCMHandler {
    private func handlePartnerChatRoomStatus(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let statusStr = data["isInChat"] as? String,
              let status = Bool(statusStr) else { return }
        partnerChatRoomStatusObservable.accept(status)
    }
}

// MARK: Couple
extension FCMHandler {
    private func handleCreateCouple(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        createCoupleObservable.accept(true)
        
        if !isBackground {
            return
        }
        
        let title = data["title"] as? String ?? "연인 등록을 완료했어요"
        showNotification(identifier: title,
                         title: title,
                         body: data["message"] as? String ?? "앱에 들어와서 확인해보세요")
    }
}

// MARK: Question
extension FCMHandler {
    private func handleTodayQuestion(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let title = data["title"] as? String else { return }
        guard let message = data["message"] as? String else { return }
//        guard let index  = data["index"] as? String else { return }
        
        showNotification(identifier: UUID().uuidString,
                         title: title,
                         body: message)
    }
    
    private func handleQuestionChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let coupleQuestionJsonStr  = data["coupleQuestion"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        guard let coupleQuestionData = coupleQuestionJsonStr.data(using: .utf8, allowLossyConversion: false) else {
            return
        }
        guard let coupleQuestion = try? JSONSerialization.jsonObject(with: coupleQuestionData, options: .mutableContainers) as? [String: Any] else {
            return
        }
        guard let questionIndex = coupleQuestion["index"] as? Int else {
            return
        }
        
        chatObservable.accept(
            QuestionChat(
                index: index,
                type: .questionChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                questionIndex: questionIndex
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(질문 채팅)")
    }
    
    private func handleAnswerChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let coupleQuestionJsonStr  = data["coupleQuestion"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        guard let coupleQuestionData = coupleQuestionJsonStr.data(using: .utf8, allowLossyConversion: false) else { return }
        guard let coupleQuestion = try? JSONSerialization.jsonObject(with: coupleQuestionData, options: .mutableContainers) as? [String: Any] else { return }
        guard let questionIndex = coupleQuestion["index"] as? Int else { return }
        
        chatObservable.accept(
            QuestionChat(
                index: index,
                type: .answerChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                questionIndex: questionIndex
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(답변 채팅)")
    }
    
    private func handlePressForAnswerChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let chatIndexStr = data["index"] as? String,
              let chatIsReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let questionIndexStr = data["coupleQuestion"] as? String,
              let questionIndex = Int(questionIndexStr),
              let identifier = data["gcm.message_id"] as? String,
              let index = Int(chatIndexStr),
              let isRead = Bool(chatIsReadStr) else { return }
        
        chatObservable.accept(
            QuestionChat(
                index: index,
                type: .pressForAnswerChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                questionIndex: questionIndex
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(콕찌르기 채팅)")
        
    }
    
    private func handleAnswerQuestionChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let title = data["title"] as? String,
              let message = data["message"] as? String,
              let indexStr = data["index"] as? String else { return }
        
        showNotification(
            identifier: UUID().uuidString,
            title: title,
            body: message
        )
    }
}

// MARK: Challenge
extension FCMHandler {
    private func handleChallenge(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let coupleChallengeJsonStr  = data["coupleChallenge"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        guard let coupleChallengeData = coupleChallengeJsonStr.data(
                  using: .utf8,
                  allowLossyConversion: false
              ),
              let coupleChallenge = try? JSONSerialization.jsonObject(
                with: coupleChallengeData,
                options: .mutableContainers
              ) as? [String: Any],
              let challengeIndex = coupleChallenge["index"] as? Int,
              let challengeTitleStr = coupleChallenge["challengeTitle"] as? String,
              let challengeDeadline = coupleChallenge["deadline"] as? String
              else { return }
        
        chatObservable.accept(
            ChallengeChat(
                index: index,
                type: .challengeChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                challengeIndex: challengeIndex,
                challengeTitle: challengeTitleStr,
                challengeDeadline: challengeDeadline
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(챌린지 채팅)")
    }
    
    private func handleAddChallenge(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let coupleChallengeJsonStr  = data["coupleChallenge"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        guard let coupleChallengeData = coupleChallengeJsonStr.data(
                  using: .utf8,
                  allowLossyConversion: false
              ),
              let coupleChallenge = try? JSONSerialization.jsonObject(
                with: coupleChallengeData,
                options: .mutableContainers
              ) as? [String: Any],
              let challengeIndex = coupleChallenge["index"] as? Int,
              let challengeTitleStr = coupleChallenge["challengeTitle"] as? String,
              let challengeDeadline = coupleChallenge["deadline"] as? String
              else { return }
        
        chatObservable.accept(
            ChallengeChat(
                index: index,
                type: .addChallengeChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                challengeIndex: challengeIndex,
                challengeTitle: challengeTitleStr,
                challengeDeadline: challengeDeadline
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(챌린지 추가 채팅)")
    }
    
    private func handleCompleteChallenge(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let coupleChallengeJsonStr  = data["coupleChallenge"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        guard let coupleChallengeData = coupleChallengeJsonStr.data(
                  using: .utf8,
                  allowLossyConversion: false
              ),
              let coupleChallenge = try? JSONSerialization.jsonObject(
                with: coupleChallengeData,
                options: .mutableContainers
              ) as? [String: Any],
              let challengeIndex = coupleChallenge["index"] as? Int,
              let challengeTitleStr = coupleChallenge["challengeTitle"] as? String,
              let challengeDeadline = coupleChallenge["deadline"] as? String
              else { return }
        
        chatObservable.accept(
            ChallengeChat(
                index: index,
                type: .completeChallengeChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                challengeIndex: challengeIndex,
                challengeTitle: challengeTitleStr,
                challengeDeadline: challengeDeadline
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(identifier: CHATTNING_NOTIFICATION_ID,
                         title: "연인",
                         body: "(챌린지 완료 채팅)")
    }
    
    private func handleDeleteChallenge(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let index  = data["index"] as? String else { return }
    }
    
    private func handleModifyChallenge(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let index  = data["index"] as? String else { return }
        let title  = data["title"] as? String ?? "연인이 챌린지를 수정했어요"
        let message  = data["message"] as? String ?? "앱에 들어와서 확인해보세요"
        
        showNotification(
            identifier: UUID().uuidString,
            title: title,
            body: message
        )
    }
    
}

// MARK: Signal
extension FCMHandler {
    private func handleSignalChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let signalTypeStr = data["signal"] as? String,
              let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let signalType = mappingSignalType(signalTypeStr),
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        chatObservable.accept(
            SignalChat(
                index: index,
                type: .signalChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                signal: signalType
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(
            identifier: CHATTNING_NOTIFICATION_ID,
            title: "연인",
            body: "(시그널 채팅)"
        )
    }
    
    private func mappingSignalType(_ str: String) -> SignalType? {
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

// chatting
extension FCMHandler {
    private func handleTextChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let messageStr = data["message"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        chatObservable.accept(
            TextChat(
                index: index,
                type: .textChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                text: messageStr
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(
            identifier: CHATTNING_NOTIFICATION_ID,
            title: "연인",
            body: messageStr
        )
    }
    
    private func handleVoiceChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let urlStr = data["url"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        chatObservable.accept(
            VoiceChat(
                index: index,
                type: .voiceChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                voiceURL: urlStr
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(
            identifier: CHATTNING_NOTIFICATION_ID,
            title: "연인",
            body: "(보이스 채팅)"
        )
    }
    
    private func handleImageChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let urlStr = data["url"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        chatObservable.accept(
            ImageChat(
                index: index,
                type: .imageChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr,
                imageURL: urlStr
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(
            identifier: CHATTNING_NOTIFICATION_ID,
            title: "연인",
            body: "(이미지 채팅)"
        )
    }
    
    private func handleResetPartnerPasswordChatting(_ data: [AnyHashable: Any], _ isBackground: Bool) {
        guard let indexStr = data["index"] as? String,
              let isReadStr = data["isRead"] as? String,
              let createAtStr = data["createAt"] as? String,
              let identifier = data["gcm.message_id"] as? String,
              let isRead = Bool(isReadStr),
              let index = Int(indexStr) else { return }
        
        chatObservable.accept(
            ResetPartenrPasswordChat(
                index: index,
                type: .resetPartnerPasswordChatting,
                isRead: isRead,
                isMine: false,
                createAt: createAtStr
            )
        )
        
        if (!isBackground && meIsInChatObsesrvable.value) {
            return
        }
        
        showNotification(
            identifier: CHATTNING_NOTIFICATION_ID,
            title: "연인",
            body: "(잠금 해제 요청 채팅)"
        )
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
        
        userNotificationCenter.add(request) { error in
            if error != nil { print("알림 띄우기 에러: \(error!.localizedDescription)") }
        }
    }
}
