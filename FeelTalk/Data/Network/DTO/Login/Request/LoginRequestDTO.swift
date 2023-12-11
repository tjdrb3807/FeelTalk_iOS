//
//  LoginRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/21.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let oauthId: String
    let snsType: String
}
