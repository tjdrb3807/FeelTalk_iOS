//
//  ReLoginResponseDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation

struct ReLoginReseponseDTO: Decodable {
    let signUpState: String
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case signUpState
        case accessToken
        case refreshToken
        case expiresIn
    }
}

// MARK: - Mapping to domain
extension ReLoginReseponseDTO {
    func toDomain() -> Login {
        let signUpState = signUpState == "newbie" ? SignUpState.newbie : (signUpState == "solo" ? SignUpState.solo : SignUpState.couple)
        return .init(signUpState: signUpState,
                     accessToken: accessToken,
                     refreshToken: refreshToken,
                     expiresIn: expiresIn)
    }
}
