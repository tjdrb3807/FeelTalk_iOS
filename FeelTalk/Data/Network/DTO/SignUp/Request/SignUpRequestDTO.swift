//
//  SignUpRequestDTO.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let snsType: SNSType.RawValue
    let nickname: String
    let refreshToken: String?           // kakao, naver
    let authCode: String?               // google
    let idToken: String?                // google
    let state: String?                  // appleAndroid
    let authorizationCode: String?      // appleIOS
    let fcmToken: String
    let marketingConsent: Bool
}
