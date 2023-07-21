//
//  ReLoginRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation

struct ReLoginRequestDTO: Encodable {
    let snsType: SNSType.RawValue
    let refreshToken: String?
    let authCode: String?
    let idToken: String?
    let state: String?
    let authorizationCode: String?
}
