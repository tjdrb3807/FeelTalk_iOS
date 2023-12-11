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

enum KakaoLoginError: Error {
    case refreshTokenError
    case idTokenError
    case idError
}

final class DefaultKakaoRepository: KakaoRepository {
    private let disposeBag = DisposeBag()
    
    func login() -> Single<SNSLogin01> {
        Single.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    
                    
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        self.getOauthId()
                            .asObservable()
                            .subscribe { id in
                                observer(.success(SNSLogin01(oauthId: id,
                                                             snsType: SNSType.kakao.rawValue)))
                            }.disposed(by: self.disposeBag)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        observer(.failure(error))
                    } else {
                        self.getOauthId()
                            .asObservable()
                            .subscribe { id in
                                observer(.success(SNSLogin01(oauthId: id,
                                                             snsType: SNSType.kakao.rawValue)))
                            }.disposed(by: self.disposeBag)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}

extension DefaultKakaoRepository {
    private func getOauthId() -> Single<String> {
        Single.create { observer -> Disposable in
            UserApi.shared.me { (user, error) in
                if let error = error {
                    observer(.failure(error))
                } else {
                    guard let id = user?.id else {
                        observer(.failure(KakaoLoginError.idError))
                        
                        return
                    }
                    
                    let oauthId = String(id)
                    observer(.success(oauthId))
                }
            }
            
            return Disposables.create()
        }
    }
}
