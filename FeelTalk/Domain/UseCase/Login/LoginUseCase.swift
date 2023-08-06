//
//  LoginUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginUseCase {
    func reLogin(snsType: SNSType,
                 refreshToken: String?,
                 authCode: String?,
                 idToken: String?,
                 state: String?,
                 authorizationCode: String?) -> Single<SignUpState>
    
    func appleLogin() -> PublishRelay<SNSLogin>
    func googleLogin() -> Single<SNSLogin>
    func naverLogin() -> Observable<SNSLogin>
    func kakaoLogin() -> Single<SNSLogin>
}

final class DefaultLoginUseCase: LoginUseCase {
    // MARK: Dependencies
    private let loginRepository: LoginRepository
    private let appleRepository: AppleRepository
    private let googleRepository: GoogleRepository
    private let naverRepository: NaverRepository
    private let kakaoRepository: KakaoRepository
    
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepository,
         appleRepository: AppleRepository,
         googleRepositroy: GoogleRepository,
         naverRepository: NaverRepository,
         kakaoRepository: KakaoRepository) {
        self.loginRepository = loginRepository
        self.appleRepository = appleRepository
        self.googleRepository = googleRepositroy
        self.naverRepository = naverRepository
        self.kakaoRepository = kakaoRepository
    }
    
    // MARK: Default busniess logic
    func reLogin(snsType: SNSType,
                 refreshToken: String?,
                 authCode: String?,
                 idToken: String?,
                 state: String?,
                 authorizationCode: String?) -> Single<SignUpState> {
        return Single.create { [weak self] observer -> Disposable in
            print("[CALL]: LoginUseCase.reLogin")
            guard let self = self else { return Disposables.create() }
            loginRepository.reLogin(snsType: snsType,
                                    refreshToken: refreshToken,
                                    authCode: authCode,
                                    idToken: idToken,
                                    state: state,
                                    authorizationCode: authorizationCode)
            .subscribe { event in
                
                switch event {
                case .success(let login):
                    guard login.signUpState == .newbie else {
                        // 이미 회원가입을 한 경우 토큰, 만료시간 현시점 기준으로 업데이트
                        guard let accessToken = login.accessToken,
                              let refreshToken = login.refreshToken,
                              let expiresIn = login.expiresIn
                        else { return }
                        
                        let expiresTiem = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
                        
                        //TODO: expiresIn 추가 로직 필요
                        KeychainRepository.updateItem(value: accessToken, key: "accessToken") &&
                        KeychainRepository.updateItem(value: refreshToken, key: "refreshToken") ?
                        observer(.success(login.signUpState)) :
                        //TODO: 에러처리 리팩토링 필요
                        debugPrint("[ERROR]: LoginUseCase token update failed.")
                        return
                    }
                    
                    // 신규 회원가입을 한 경우 signUpState만 success로 전달
                    observer(.success(login.signUpState))
                case .failure(let error):
                    observer(.failure(error))
                }
            }.disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: SNS login busniess logic.
extension DefaultLoginUseCase {
    func appleLogin() -> PublishRelay<SNSLogin> {
        debugPrint("[CALL]: LoginUseCase - appleLogin")
        appleRepository.login()
        
        return appleRepository.loginCompleted
    }
    
    func googleLogin() -> Single<SNSLogin> {
        debugPrint("[CALL]: LoginUseCase - googleLogin")
        return googleRepository.login()
    }
    
    func naverLogin() -> Observable<SNSLogin> {
        debugPrint("[CALL]: LoginUseCase - naverLogin")
        naverRepository.login()
        
        return naverRepository.snsLoginInfo
    }
    
    func kakaoLogin() -> Single<SNSLogin> {
        debugPrint("[CALL]: LoginUseCAse - kakaoLogin")
        return kakaoRepository.login()
    }
}


