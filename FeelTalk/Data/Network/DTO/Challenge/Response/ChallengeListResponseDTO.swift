//
//  ChallengeListResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct ChallengeListResponseDTO: Decodable {
    let challenges: [ChallengeBaseResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case challenges
    }
}
