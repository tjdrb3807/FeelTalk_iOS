//
//  SignUpUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import RxSwift

protocol SignUpUseCase {
    func getAuthNumber(_ entity: UserAuthInfo) -> Observable<String>
    
    func getReAuthNumber(_ sessionUuid: String) -> Observable<Bool>
    
    func verifyAnAdult(authNumber: String, sessionUuid: String) -> Observable<Bool>
    
    func signUp(_ model: SignUpInfo) -> Observable<Bool>
}

final class DefaultSignUpUseCase: SignUpUseCase {
    private let signUpRepository: SignUpRepository
    private let tokenStore: AuthTokenStore
    private let pushTokenProvider: PushTokenProvider
    private let disposeBag = DisposeBag()
    
    init(signUpRepository: SignUpRepository,
         tokenStore: AuthTokenStore,
         pushTokenProvider: PushTokenProvider) {
        self.signUpRepository = signUpRepository
        self.tokenStore = tokenStore
        self.pushTokenProvider = pushTokenProvider
    }
    
    func getAuthNumber(_ entity: UserAuthInfo) -> Observable<String> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let requestDTO = entity.convertAuthNumberRequestDTO() else { return Disposables.create() }
            
            self.signUpRepository.getAuthNumber(requestDTO)
                .asObservable()
                .catch({ error in
                    return Observable.just("")
                })
                .subscribe(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getReAuthNumber(_ sessionUuid: String) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            let requestDTO = ReAuthNumberRequestDTO(sessionUuid: sessionUuid)
            
            self.signUpRepository.getReAuthNumber(requestDTO)
                .asObservable()
                .subscribe(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func verifyAnAdult(authNumber: String, sessionUuid: String) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            self.signUpRepository.verifyAnAdult(VerificationRequestDTO(authNumber: authNumber, sessionUuid: sessionUuid))
                .asObservable()
                .subscribe(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func signUp(_ model: SignUpInfo) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            guard let accessToken = self.tokenStore.loadAccessToken() else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()}

            self.pushTokenProvider.fetchToken()
                .asObservable()
                .flatMap { token -> Observable<Bool> in
                    guard let token else { return Observable.just(false) }

                    let requestDTO = SignUpRequestDTO(
                        accessToken: accessToken,
                        nickname: model.nickname,
                        marketingConsent: model.marketingConsent,
                        fcmToken: token)

                    return self.signUpRepository.signUp(requestDTO).asObservable()
                }.subscribe(onNext: { state in
                    observer.onNext(state)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
