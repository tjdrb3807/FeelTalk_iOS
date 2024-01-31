//
//  GetPartnerInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetPartnerInfoResponseDTO: Decodable {
    let nickname: String
    let snsType: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case snsType
    }
}

extension GetPartnerInfoResponseDTO {
    func toDomain() -> PartnerInfo {
        .init(nickname: nickname,
              snsType: SNSType(rawValue: snsType)!)
    }
}
