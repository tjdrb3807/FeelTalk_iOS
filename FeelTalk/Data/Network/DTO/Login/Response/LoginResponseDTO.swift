//
//  LoginResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let tokenType: String
    let accessToken: String
    let refreshToken: String
    let expiredTime: String
        
    enum CodingKeys: String, CodingKey {
        case tokenType
        case accessToken
        case refreshToken
        case expiredTime
    }
}

extension LoginResponseDTO {
    func toDomain() -> Token01 {
        .init(accessToken: self.accessToken,
              refreshToken: self.refreshToken,
              expiredTime: self.expiredTime)
    }
}
