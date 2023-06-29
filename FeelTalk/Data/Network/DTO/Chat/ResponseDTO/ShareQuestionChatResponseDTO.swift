//
//  ShareQuestionChatResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct ShareQuestionChatResponseDTO: Decodable {
    let coupleQuestion: CoupleQuestionChatResponseDTO?
    let index: Int?
    let isRead: Bool?
    let createAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case coupleQuestion
        case index
        case isRead
        case createAt
    }
}
