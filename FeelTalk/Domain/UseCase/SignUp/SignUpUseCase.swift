//
//  SignUpUseCase.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/06.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseMessaging

protocol SignUpUseCase {
    func getAuthNumber(_ entity: UserAuthInfo) -> Observable<String>
    
    func getReAuthNumber(_ entity: UserAuthInfo) -> Observable<Bool>
    
    func verifyAnAdult(authNumber: String, sessionUuid: String) -> Observable<Bool>
    
    func signUp(_ model: SignUpInfo) -> Observable<Bool>
}

final class DefaultSignUpUseCase: SignUpUseCase {
    private let signUpRepository: SignUpRepository
    private let disposeBag = DisposeBag()
    
    init(signUpRepository: SignUpRepository) {
        self.signUpRepository = signUpRepository
    }
    
    func getAuthNumber(_ entity: UserAuthInfo) -> Observable<String> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let requestDTO = entity.convertAuthNumberRequestDTO() else { return Disposables.create() }
            
            self.signUpRepository.getAuthNumber(requestDTO)
                .asObservable()
                .subscribe(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func getReAuthNumber(_ entity: UserAuthInfo) -> Observable<Bool> {
        Observable.create { [weak self] observer -> Disposable in
            guard let self = self,
                  let requestDTO = entity.convertReAuthNumberRequestDTO() else { return Disposables.create() }
            
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
            guard let self = self,
                  let accessToken = KeychainRepository.getItem(key: "accessToken") as? String
                   else { return Disposables.create() }
            
//            let fcmToken = KeychainRepository.getItem(key: "fcmToken") as? String ?? Messaging.messaging().fcmToken
            
            let fcmToken: String? = "TestFcmToken"
            
            print("fcm token (when sign up): \(String(describing: fcmToken))")
            
            if fcmToken == nil {
                return Disposables.create()
            }

            let requestDTO = SignUpRequestDTO(accessToken: accessToken,
                                              nickname: model.nickname,
                                              marketingConsent: model.marketingConsent,
                                              fcmToken: fcmToken!)

            self.signUpRepository.signUp(requestDTO)
                .asObservable()
                .subscribe(onNext: { state in
                    observer.onNext(state)
                }).disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
