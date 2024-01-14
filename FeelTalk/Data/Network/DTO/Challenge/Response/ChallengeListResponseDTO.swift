//
//  ChallengeListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct ChallengeListResponseDTO: Decodable {
    let challengeList: [ChallengeBaseResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case challengeList
    }
}
