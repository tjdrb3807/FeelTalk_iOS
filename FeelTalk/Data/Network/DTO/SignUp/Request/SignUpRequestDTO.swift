//
//  SignUpRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/18.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let accessToken: String
    var state: String?
    let nickname: String
    let marketingConsent: Bool
    let fcmToken: String
}
