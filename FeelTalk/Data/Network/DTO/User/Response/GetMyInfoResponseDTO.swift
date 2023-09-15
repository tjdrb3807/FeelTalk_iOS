//
//  GetMyInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetMyInfoResponseDTO: Decodable {
    let nickname: String
    let snsType: String
}

extension GetMyInfoResponseDTO {
    func toDomain() -> MyInfo {
        .init(nickname: nickname,
              snsType: SNSType(rawValue: snsType)!)
    }
}
