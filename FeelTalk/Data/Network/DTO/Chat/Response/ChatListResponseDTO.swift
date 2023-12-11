//
//  ChatListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

struct ChatListResponseDTO: Decodable {
    let page: Int
    let chatList: [ChatResponseDTO]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case chatList = "chatting"
    }
}

struct ChatResponseDTO: Decodable {
    let index: Int
    let type: ChatType.RawValue
    let sender: String
    let isRead: Bool
    let isMine: Bool
    let createAt: String
    let text: String?
    let question: Int?
    let challenge: ChallengeChatResponseDTO?
    let emoji: String?
    let url: String?
    let signal: SignalType.RawValue?
    
    enum CodingKeys: String, CodingKey {
        case index
        case type
        case sender = "chatSender"
        case isRead
        case isMine = "mine"
        case createAt
        case text = "message"
        case question = "coupleQuestion"
        case challenge = "coupleChallenge"
        case emoji
        case url
        case signal
    }
}

struct ChallengeChatResponseDTO: Decodable {
    let index: Int
    let title: String
    let content: String
    let deadline: String
    let creator: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case title = "challengeTitle"
        case content = "challengeBody"
        case deadline
        case creator
    }
}

extension ChatResponseDTO {
    func toDomain() -> Chat? {
        if let type = ChatType(rawValue: self.type) {
            switch type {
            case .addChallengeChatting:
                return ChallengeChat(index: self.index,
                                     type: type,
                                     isRead: self.isRead,
                                     isMine: self.isMine,
                                     createAt: self.createAt,
                                     challengeIndex: self.challenge!.index,
                                     challengeTitle: self.challenge!.title,
                                     challengeDeadline: self.challenge!.deadline)
            case .answerChatting:
                return QuestionChat(index: self.index,
                                    type: type,
                                    isRead: self.isRead,
                                    isMine: self.isMine,
                                    createAt: self.createAt,
                                    questionIndex: self.question!)
            case .textChatting:
                return TextChat(index: self.index,
                                type: type,
                                isRead: self.isRead,
                                isMine: self.isMine,
                                createAt: self.createAt,
                                text: self.text!)
            case .voiceChatting:
                return VoiceChat(index: self.index,
                                 type: type,
                                 isRead: self.isRead,
                                 isMine: self.isMine,
                                 createAt: self.createAt,
                                 voiceURL: self.url!)
            case .imageChatting:
                return ImageChat(index: self.index,
                                 type: type,
                                 isRead: self.isRead,
                                 isMine: self.isMine,
                                 createAt: self.createAt,
                                 imageURL: self.url!)
            case .questionChatting:
                return QuestionChat(index: self.index,
                                    type: type,
                                    isRead: self.isRead,
                                    isMine: self.isMine,
                                    createAt: self.createAt,
                                    questionIndex: self.question!)
            case .challengeChatting:
                return ChallengeChat(index: self.index,
                                     type: type,
                                     isRead: self.isRead,
                                     isMine: self.isMine,
                                     createAt: self.createAt,
                                     challengeIndex: self.challenge!.index,
                                     challengeTitle: self.challenge!.title,
                                     challengeDeadline: self.challenge!.deadline)
            case .emojiChatting:
                return EmojiChat(index: self.index,
                                 type: type,
                                 isRead: self.isRead,
                                 isMine: self.isMine,
                                 createAt: self.createAt,
                                 emoji: self.emoji!)
            case .resetPartnerPasswordChatting:
                return RestPartenrPasswordChat(index: self.index,
                                               type: type,
                                               isRead: self.isRead,
                                               isMine: self.isMine,
                                               createAt: self.createAt)
            case .pressForAnswerChatting:
                return QuestionChat(index: self.index,
                                    type: type,
                                    isRead: self.isRead,
                                    isMine: self.isMine,
                                    createAt: self.createAt,
                                    questionIndex: self.question!)
            case .completeChallengeChatting:
                return ChallengeChat(index: self.index,
                                     type: type,
                                     isRead: self.isRead,
                                     isMine: self.isMine,
                                     createAt: self.createAt,
                                     challengeIndex: self.challenge!.index,
                                     challengeTitle: self.challenge!.title,
                                     challengeDeadline: self.challenge!.deadline)
            case .signalChatting:
                return SignalChat(index: self.index,
                                  type: type,
                                  isRead: self.isRead,
                                  isMine: self.isMine,
                                  createAt: self.createAt,
                                  signal: SignalType(rawValue: self.signal!)!)
            }
        }
        
        return nil
    }
}
