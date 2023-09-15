//
//  GetChallengeCountResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct GetChallengeCountResponseDTO: Decodable {
    let totalCount: Int
    let ongoingCount: Int
    let completedCount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount
        case ongoingCount
        case completedCount
    }
}

extension GetChallengeCountResponseDTO {
    func toDomain() -> ChallengeCount {
        .init(totalCount: totalCount,
              ongoingCount: ongoingCount,
              completedCount: completedCount)
    }
}
