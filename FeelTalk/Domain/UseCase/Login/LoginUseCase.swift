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
    
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepository, appleRepository: AppleRepository, googleRepositroy: GoogleRepository, naverRepository: NaverRepository, kakaoRepository: KakaoRepository, userRepository: UserRepository) {
        self.loginRepository = loginRepository
        self.appleRepository = appleRepository
        self.googleRepository = googleRepositroy
        self.naverRepository = naverRepository
        self.kakaoRepository = kakaoRepository
        self.userRepository = userRepository
    }
    
    func login(_ data: SNSLogin01) -> Observable<UserState> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            loginRepository
                .login(data)
                .asObservable()
                .filter {
                    KeychainRepository.addItem(value: $0.accessToken, key: "accessToken") &&
                    KeychainRepository.addItem(value: $0.refreshToken, key: "refreshToken") &&
                    KeychainRepository.addItem(value: KeychainRepository.setExpiredTime(), key: "expiredTime")
                }.compactMap { _ in KeychainRepository.getItem(key: "accessToken") as? String }
                .subscribe(onNext: { accessToken in
                    self.getUserState(accessToken)
                        .subscribe(onNext: { state in
                            observer.onNext(state)
                        }).disposed(by: self.disposeBag)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func reissuanceAccessToken(accessToken: String, refreshToken: String) -> Observable<Void>{
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            loginRepository
                .reissuanceAccessToken(
                    accessToken: accessToken,
                    refreshToken: refreshToken)
                .asObservable()
                .filter { event in
                    KeychainRepository.updateItem(value: event.accessToken, key: "accessToken") &&
                    KeychainRepository.updateItem(value: event.refreshToken, key: "refreshToken") &&
                    KeychainRepository.updateItem(value: event.expiredTime, key: "expiredTime")
                }.map { _ -> Void in }
                .subscribe(onNext: {
                    observer.onNext(())
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<Void> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            loginRepository
                .logout()
                .asObservable()
                .filter { $0 }
                .filter { _ in
                    KeychainRepository.deleteItem(key: "accessToken") &&
                    KeychainRepository.deleteItem(key: "refreshToken") &&
                    KeychainRepository.deleteItem(key: "expiredTime")
                }.map { _ -> Void in }
                .subscribe(onNext: {
                    observer.onNext(())
                }).disposed(by: disposeBag)
            
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
            
            userRepository
                .getUserState()
                .asObservable()
                .bind(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
}


