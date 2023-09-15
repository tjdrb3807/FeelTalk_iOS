//
//  GetLatestChallengePageNoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/03.
//

import Foundation

struct GetLatestChallengePageNoResponseDTO: Decodable {
    let pageNo: Int
    
    enum CodingKeys: String, CodingKey {
        case pageNo
    }
}

extension GetLatestChallengePageNoResponseDTO {
    func toDomain() -> ChallengePage {
        .init(pageNo: self.pageNo)
    }
}
