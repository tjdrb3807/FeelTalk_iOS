//
//  ChallengeLatestPageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct ChallengeLatestPageNoResponseDTO: Decodable {
    let pageNo: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}

extension ChallengeLatestPageNoResponseDTO {
    func toDomain() -> ChallengePage {
        .init(pageNo: self.pageNo)
    }
}
