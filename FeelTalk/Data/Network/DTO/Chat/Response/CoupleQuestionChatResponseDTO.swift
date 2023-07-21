//
//  CoupleQuestionChatResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct CoupleQuestionChatResponseDTO: Decodable {
    let index: Int?
    let questionTitle: String?
    let selfAnswer: String?
    let partnerAnswer: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case questionTitle
        case selfAnswer
        case partnerAnswer
    }
}
