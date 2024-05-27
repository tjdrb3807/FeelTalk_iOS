//
//  GetMyInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetMyInfoResponseDTO: Decodable {
    let id: Int
    let nickname: String
    let snsType: String
}

extension GetMyInfoResponseDTO {
    func toDomain() -> MyInfo {
        .init(id: id,
              nickname: nickname,
              snsType: SNSType(rawValue: snsType)!)
    }
}
