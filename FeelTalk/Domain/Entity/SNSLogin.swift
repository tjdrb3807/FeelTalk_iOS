//
//  SNSLogin.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/17.
//

import Foundation

struct SNSLogin {
    let snsType: SNSType
    let refreshToken: String?           // NAVER, KAKAO
    let authCode: String?               // GOOGLE
    let idToken: String?                // GOOGLE
    let state: String? = nil            // APPLE in android(iOS에서 쓸일 없음)
    let authorizationCode: String?      // APPLE in iOS
}
