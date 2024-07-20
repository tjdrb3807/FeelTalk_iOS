//
//  CompleteChallengeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/24.
//

import Foundation

struct CompleteChallengeResponseDTO: Decodable {
    let challenge: ChallengeChatResponseDTO
    let chatIndex: Int
    let chatPageIndex: Int
    let isChatRead: Bool
    let createAt: String
    
    enum CodingKeys: String, CodingKey {
        case challenge = "coupleChallenge"
        case chatIndex = "index"
        case chatPageIndex = "pageIndex"
        case isChatRead = "isRead"
        case createAt
    }
    
}

extension CompleteChallengeResponseDTO {
    func toDomain() -> ChallengeChat {
        .init(index: chatIndex,
              type: .completeChallengeChatting,
              isRead: isChatRead,
              isMine: true,
              createAt: createAt,
              challengeIndex: challenge.index,
              challengeTitle: challenge.title,
              challengeDeadline: challenge.deadline)
    }
}
