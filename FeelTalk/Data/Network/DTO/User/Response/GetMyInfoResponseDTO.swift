//
//  GetMyInfoResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/15.
//

import Foundation

struct GetMyInfoResponseDTO: Decodable {
    let id: String
    let nickname: String
    let snsType: String
}

extension GetMyInfoResponseDTO {
    func toDomain() -> MyInfo {
        .init(id: Int(id) ?? 0,
              nickname: nickname,
              snsType: SNSType(rawValue: snsType)!)
    }
}
