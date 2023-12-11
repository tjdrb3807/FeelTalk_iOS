//
//  NaverLoginResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

struct NaverLoginResponseDTO: Decodable {
    let message: String
    let info: NaverLoginInfoResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case message
        case info = "response"
    }
}

struct NaverLoginInfoResponseDTO: Decodable {
    let email: String
    let oauthId: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case oauthId = "id"
        case name
    }
}

extension NaverLoginResponseDTO {
    func toDomain() -> SNSLogin01 {
        .init(oauthId: self.info.oauthId,
              snsType: SNSType.naver.rawValue)
    }
}
