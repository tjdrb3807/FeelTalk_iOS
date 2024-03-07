//
//  AccessTokenReissuanceRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/13.
//

import Foundation

struct AccessTokenReissuanceRequestDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}
