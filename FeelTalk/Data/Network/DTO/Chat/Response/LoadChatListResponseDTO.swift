//
//  LoadChatListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct LoadChatListResponseDTO: Decodable {
    let page: Int?
    let chatting: [ChattingResponseDTO]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case chatting
    }
    
    struct ChattingResponseDTO: Decodable {
        let index: Int?
        let message: String?
        let url: URL? // 변경 가능성 있음
        let coupleQuestion: CoupleQuestionChatResponseDTO?
        let coupleChallenge: CoupleChallengeResponseDTO?
        let emoji: EmojiType.RawValue?
        let type: ChatType.RawValue?
        let createAt: Date?
        let chatSender: String?
        let isRead: Bool?
        
        enum CodingKeys: String, CodingKey {
            case index
            case message
            case url
            case coupleQuestion
            case coupleChallenge
            case emoji
            case type
            case createAt
            case chatSender
            case isRead
        }
    }
}
