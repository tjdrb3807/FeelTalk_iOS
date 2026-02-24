//
//  LoginUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift

protocol LoginUseCase {
    func login(_ data: SNSLogin01) -> Observable<UserState>
    
    func reissuanceAccessToken(accessToken: String, refreshToken: String) -> Observable<Void>
    
    func logout() -> Observable<Void>
    
    func appleLogin() -> Observable<SNSLogin01>
    
    func googleLogin() -> Single<SNSLogin01>
    
    func naverLogin() -> Observable<SNSLogin01>
    
    func kakaoLogin() -> Single<SNSLogin01>
}

final class DefaultLoginUseCase: LoginUseCase {
    // MARK: Dependencies
    private let loginRepository: LoginRepository
    private let appleRepository: AppleRepository
    private let googleRepository: GoogleRepository
    private let naverRepository: NaverRepository
    private let kakaoRepository: KakaoRepository
    private let userRepository: UserRepository
    private let tokenStore: AuthTokenStore
    private let pushTokenProvider: PushTokenProvider
    
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepository,
         appleRepository: AppleRepository,
         googleRepositroy: GoogleRepository,
         naverRepository: NaverRepository,
         kakaoRepository: KakaoRepository,
         userRepository: UserRepository,
         tokenStore: AuthTokenStore,
         pushTokenProvider: PushTokenProvider
    ) {
        self.loginRepository = loginRepository
        self.appleRepository = appleRepository
        self.googleRepository = googleRepositroy
        self.naverRepository = naverRepository
        self.kakaoRepository = kakaoRepository
        self.userRepository = userRepository
        self.tokenStore = tokenStore
        self.pushTokenProvider = pushTokenProvider
    }
    
    func login(_ data: SNSLogin01) -> Observable<UserState> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.loginRepository
                .login(data)
                .asObservable()
                .filter { [weak self] in
                    guard let self else { return false }
                    return self.tokenStore.saveAccessToken($0.accessToken)
                        && self.tokenStore.saveRefreshToken($0.refreshToken)
                        && self.tokenStore.saveExpiredTime(KeychainRepository.setExpiredTime())
                }.compactMap { [weak self] _ in
                    guard let self else { return nil }
                    return self.tokenStore.loadAccessToken()
                }.subscribe(onNext: { accessToken in
                    self.getUserState(accessToken)
                        .asObservable()
                        .catch({ error in
                            let state = self.tokenStore.loadUserStateRawValue()
                            if state == nil {
                                return Observable.error(error)
                            } else {
                                return Observable.just(UserState(rawValue: state!)!)
                            }
                        })
                        .subscribe(onNext: { state in
                            self.tokenStore.saveUserState(state.rawValue)
                            observer.onNext(state)
                        }, onError: { error in
                            let state = KeychainRepository.getItem(key: "userState") as? String
                            if state == nil {
                                observer.onError(error)
                            } else {
                                observer.onNext(UserState(rawValue: state!)!)
                            }
                        }).disposed(by: self.disposeBag)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func reissuanceAccessToken(accessToken: String, refreshToken: String) -> Observable<Void>{
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.loginRepository
                .reissuanceAccessToken(
                    accessToken: accessToken,
                    refreshToken: refreshToken)
                .asObservable()
                .filter { [weak self] event in
                    guard let self = self else { return false }
                    
                    return self.tokenStore.saveAccessToken(event.accessToken) &&
                        self.tokenStore.saveRefreshToken(event.refreshToken) &&
                        self.tokenStore.saveExpiredTime(KeychainRepository.setExpiredTime())
                }.map { _ -> Void in }
                .subscribe(onNext: {
                    observer.onNext(())
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<Void> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.loginRepository
                .logout()
                .asObservable()
                .filter { $0 }
                .filter { [weak self] _ in
                    guard let self = self else { return false }
                    
                    return self.tokenStore.clearTokens()
                }.map { _ -> Void in }
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    
                    self.pushTokenProvider.deleteToken()
                        .subscribe(onSuccess: { _ in
                            observer.onNext(())
                        }, onFailure: { error in
                            /// 푸시 토큰 삭제 실패해도 로그아웃 완료는 진행(UX)
                            print("Failed to delete push token: \(error)")
                            observer.onNext(())
                        }).disposed(by: self.disposeBag)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: SNS login busniess logic.
extension DefaultLoginUseCase {
    func appleLogin() -> Observable<SNSLogin01> {
        debugPrint("[CALL]: LoginUseCase - appleLogin")
        appleRepository.login()
        
        return appleRepository.appleLogin
    }
    
    func googleLogin() -> Single<SNSLogin01> {
        debugPrint("[CALL]: LoginUseCase - googleLogin")
        return googleRepository.login()
    }
    
    func naverLogin() -> Observable<SNSLogin01> {
        debugPrint("[CALL]: LoginUseCase - naverLogin")
        naverRepository.login()
        
        return naverRepository.snsLoginInfo
    }
    
    func kakaoLogin() -> Single<SNSLogin01> {
        debugPrint("[CALL]: LoginUseCase - kakaoLogin")
        return kakaoRepository.login()
    }
}

extension DefaultLoginUseCase {
    func getUserState(_ accessToken: String) -> Observable<UserState> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.userRepository
                .getUserState()
                .asObservable()
                .subscribe(onNext: { state in
                    observer.onNext(state)

                    if state != UserState.newbie {
                        self.userRepository.getMyInfo()
                            .subscribe(onSuccess: { myInfo in MixpanelRepository.shared.logIn(id: myInfo.id) })
                            .disposed(by: self.disposeBag)
                    }
                }, onError: { error in observer.onError(error) })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}


