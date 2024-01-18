//
//  AddChallengeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct AddChallengeResponseDTO: Decodable {
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

extension AddChallengeResponseDTO {
    func toDomain() -> ChallengeChat {
        .init(index: chatIndex,
              type: .addChallengeChatting,
              isRead: isChatRead,
              isMine: true,
              createAt: createAt,
              challengeIndex: challenge.index,
              challengeTitle: challenge.title,
              challengeDeadline: challenge.deadline)
    }
}

