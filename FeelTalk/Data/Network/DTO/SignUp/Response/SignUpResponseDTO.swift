//
//  SignUpResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expiresIn
    }
}

extension SignUpResponseDTO {
    func toDomain() -> Token {
        return .init(accessToken: accessToken,
                     refreshToken: refreshToken,
                     expiresIn: expiresIn)
    }
}
