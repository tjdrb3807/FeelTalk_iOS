//
//  RenewAccessTokenRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/20.
//

import Foundation

struct RenewAccessTokenRequestDTO: Encodable {
    let refreshToken: String
}
