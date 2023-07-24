//
//  KakaoRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/13.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import RxCocoa

enum KakaoSignUpError: Error {
    case refreshTokenError
}

final class DefaultKakaoRepository: KakaoRepository {
    func login() -> Single<SNSLogin> {
        debugPrint("[CALL]: KakaoRepository - login")
        return Single.create { observer -> Disposable in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        guard let refreshToken = oauthToken?.refreshToken else {
                            observer(.failure(KakaoLoginError.refreshTokenError))
                            return
                        }
                                                
                        observer(.success(SNSLogin(snsType: .kakao,
                                                   refreshToken: refreshToken,
                                                   authCode: nil,
                                                   idToken: nil,
                                                   authorizationCode: nil))
                        )
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        guard let refreshToken = oauthToken?.refreshToken else {
                            observer(.failure(KakaoLoginError.refreshTokenError))
                            return
                        }
                        
                        observer(.success(SNSLogin(snsType: .kakao,
                                                   refreshToken: refreshToken,
                                                   authCode: nil,
                                                   idToken: nil,
                                                   authorizationCode: nil))
                        )
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
