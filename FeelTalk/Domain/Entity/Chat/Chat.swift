//
//  Chat.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/20.
//

import Foundation
import UIKit

protocol Chat {
    var index: Int { get set }
    var type: ChatType { get set }
    var isRead: Bool { get set }
    var isMine: Bool { get set }
    var createAt: String { get set }
    var updateCount: Int { get set }
}

struct PressForAnswerOpenGraphChat: Chat {
    var index: Int
//    var pageIndex: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var questionIndex: Int
    var createAt: String
    var updateCount: Int = 0
}

/// 메세지 채팅 Entity
struct TextChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let text: String
    var updateCount: Int = 0
}

/// 음성녹음 채팅 Entity
struct VoiceChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let voiceURL: String
    var voiceFile: Data? = nil
    var updateCount: Int = 0
}

/// 질문 채팅 Entity
struct QuestionChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let questionIndex: Int
    var question: Question? = nil
    var updateCount: Int = 0
}

/// 챌린지 채팅 Entity
struct ChallengeChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let challengeIndex: Int
    let challengeTitle: String
    let challengeDeadline: String
    var challenge: Challenge? = nil
    var updateCount: Int = 0
}

/// 이모티콘 채팅 Entity
struct EmojiChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let emoji: String
    var updateCount: Int = 0
}

/// 이미지 채팅 Entity
struct ImageChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    var imageURL: String
    var uiImage: UIImage? = nil
    var updateCount: Int = 0
}

/// 시그널 채팅 Entity
struct SignalChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    let signal: SignalType
    var updateCount: Int = 0
}

/// 비밀번호 재설정 요청 채팅 Entity
struct ResetPartenrPasswordChat: Chat {
    var index: Int
    var type: ChatType
    var isRead: Bool
    var isMine: Bool
    var createAt: String
    var updateCount: Int = 0
}
