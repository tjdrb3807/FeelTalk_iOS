//
//  CoupleChallengeResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/29.
//

import Foundation

struct CoupleChallengeResponseDTO: Decodable {
    let index: Int?
    let category: ChallengeCategoryType.RawValue?
    let challengeTitle: String?
    let challengeBody: String?
    let deadline: Date?
    let creator: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case category
        case challengeTitle
        case challengeBody
        case deadline
        case creator
    }
}
