//
//  SignUpInfo.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation

struct SignUp {
    let snsType: SNSType
    var nickname: String
    let refreshToken: String?          // Google, Kakao
    let authCode: String?              // Google
    let idToken: String?               // Google
    let state: String? = nil           // Android in apple (iOS 에서는 사용하지 않는다.)
    let authorizationCode: String?     // iOS in apple
    let marketingConsent: Bool
}
