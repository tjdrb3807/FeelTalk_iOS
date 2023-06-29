//
//  KakaoRepository.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/13.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import RxCocoa

enum KakaoSignUpError: Error {
    case refreshTokenError
}

class KakaoRepository {
    private let disposeBag = DisposeBag()    
    static let shared = KakaoRepository()
    
    func login() -> Observable<String> {
        return Observable.create { observer -> Disposable in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error { observer.onError(error) }
                    else {
                        guard let refreshToken = oauthToken?.refreshToken else {
                            observer.onError(KakaoSignUpError.refreshTokenError)
                            return
                        }

                        observer.onNext(refreshToken)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error = error { observer.onError(error) }
                        else {
                            guard let refreshToken = oauthToken?.refreshToken else {
                                observer.onError(KakaoSignUpError.refreshTokenError)
                                return
                            }

                            observer.onNext(refreshToken)
                        }
                    }
            }
            return Disposables.create()
        }
    }
}
