//
//  SignUpInfo.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation

struct SignUpInfo {
    let snsType: SNSType
    let refreshToken: String?
    let authCode: String?
    let idToken: String?
    let state: String? = nil
    let authorizationCode: String?
    let marketingConsent: Bool
}
