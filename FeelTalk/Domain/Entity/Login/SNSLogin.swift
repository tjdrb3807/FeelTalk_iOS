//
//  SNSLogin.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/17.
//

import Foundation

/// Google, NAVER, KAKAO 만 사용
struct SNSLogin {
    let snsType: SNSType
    let refreshToken: String?           // NAVER, KAKAO
    let authCode: String?               // GOOGLE
    let idToken: String?                // GOOGLE
    let state: String? = nil            // APPLE in android(iOS에서 쓸일 없음)
    let authorizationCode: String?      // APPLE in iOS
//    let oauthId: String
//    let snsType: SNSType.RawValue
}

struct SNSLogin01 {
    let oauthId: String
    let snsType: SNSType.RawValue
}

extension SNSLogin01 {
    func toDTO() -> LoginRequestDTO {
        .init(oauthId: self.oauthId,
              snsType: self.snsType)
    }
}
