//
//  ShareChallengeChatResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct ShareChallengeChatResponseDTO: Decodable {
    let coupleChallenge: CoupleChallengeResponseDTO?
    let index: Int?
    let isRead: Bool?
    let createAt: Data?
    
    enum CodingKeys: String, CodingKey {
        case coupleChallenge
        case index
        case isRead
        case createAt
    }
}
