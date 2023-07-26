//
//  SignUpUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpUseCase {    
    func signUp(snsType: SNSType,
                  nickname: String,
                  refreshToken: String?,
                  authCode: String?,
                  idToken: String?,
                  state: String?,
                  authorizationCode: String?,
                  marketingConsent: Bool)
}

final class DefaultSignUpUseCase: SignUpUseCase {
    private let signUpRepository: SignUpRepository
    
    private let disposeBag = DisposeBag()
    
    init(signUpRepository: SignUpRepository) {
        self.signUpRepository = signUpRepository
    }
    
    func signUp(snsType: SNSType,
                nickname: String,
                refreshToken: String?,
                authCode: String?,
                idToken: String?,
                state: String?,
                authorizationCode: String?,
                marketingConsent: Bool) {
        print("[CALL]: SignUpUscCase.signUp")
        guard let fcmToken = KeychainRepository.getItem(key: "fcmToken") as? String else { return }
        
        signUpRepository.signUp(snsType: snsType,
                                nickname: nickname,
                                refreshToken: refreshToken,
                                authCode: authCode,
                                idToken: idToken,
                                state: state,
                                authorizationCode: authorizationCode,
                                fcmToken: fcmToken,
                                marketingConsent: marketingConsent)
        .subscribe { event in
            switch event {
            case .success(let token):
                print("scuccess")
                // 신규 회원가입이므로 토큰 저장
                KeychainRepository.addItem(value: token.accessToken, key: "accessToken") &&
                KeychainRepository.addItem(value: token.refreshToken, key: "refreshToken") ?
                debugPrint("[SUCCESS]: accessToken, refreshToken created.") :
                debugPrint("[ERROR]: accessToken, refreshToken fail.")
            case .failure(let error):
                print("fail")
                debugPrint("\(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }
}
