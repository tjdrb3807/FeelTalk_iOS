//
//  GetPartnerInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetPartnerInfoResponseDTO: Decodable {
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
    }
}

extension GetPartnerInfoResponseDTO {
    func toDomain() -> PartnerInfo {
        .init(nickname: nickname)
    }
}
