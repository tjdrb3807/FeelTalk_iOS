//
//  ChatListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/19.
//

import Foundation

struct ChatListResponseDTO: Decodable {
    let page: Int
    let chatting: [ChattingResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case chatting
    }
}

struct ChattingResponseDTO: Decodable {
    let index: Int
    let message: String?
    let url: String?
    let coupleQuestion: CoupleQuestionResponseDTO?
    let coupleChallenge: CoupleChallengeResponseDTO?
    let type: String
    let createAt: String
    let chatSender: String
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case url
        case coupleQuestion
        case coupleChallenge
        case type
        case createAt
        case chatSender
        case isRead
    }
}

struct CoupleQuestionResponseDTO: Decodable {
    let index: Int
    let questionTitle: String
    let selfAnswer: String?
    let partnerAnswer: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case questionTitle
        case selfAnswer
        case partnerAnswer
    }
}

struct CoupleChallengeResponseDTO: Decodable {
    let index: Int
    let challengeTitle: String
    let challengeBody: String
    let deadline: String
    let creator: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case challengeTitle
        case challengeBody
        case deadline
        case creator
    }
}
