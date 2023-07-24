//
//  LoginViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewControllable: AnyObject {
    func performTransition(_ loginViewModel: LoginViewModel, to transition: loginFlow)
}

protocol SendSNSLoginDataDelegate: AnyObject {
    func reciveData(reseponse: SNSLogin)
}

class LoginViewModel {
    // Dependencies
    private let loginUseCase: LoginUseCase
    weak var controllable: LoginViewControllable?
    weak var delegate: SendSNSLoginDataDelegate?
    
    private let disposeBag = DisposeBag()
    
    private let signUpState = PublishRelay<SignUpState>()
    private let snsLogin = PublishRelay<SNSLogin>()

    struct Input {
        let tapAppleLoginButton: ControlEvent<Void>
        let tapGoogleLoginButton: ControlEvent<Void>
        let tapKakaoLoginButton: ControlEvent<Void>
        let tapNaverLoginButton: ControlEvent<Void>
    }
    
    struct Output {
        
    }

    init(loginControllable: LoginViewControllable, delegate: SendSNSLoginDataDelegate, loginUseCase: LoginUseCase) {
        self.controllable = loginControllable
        self.delegate = delegate
        self.loginUseCase = loginUseCase
    }
    
    func transfer(input: Input) -> Output {
        // APPLE Login
        input.tapAppleLoginButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.loginUseCase.appleLogin()
                    .bind(to: vm.snsLogin)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // GOOGLE Login
        input.tapGoogleLoginButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.loginUseCase.googleLogin()
                    .asObservable()
                    .bind(to: vm.snsLogin)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // KAKAO Login
        input.tapKakaoLoginButton
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                vm.loginUseCase.kakaoLogin()
                    .asObservable()
                    .bind(to: vm.snsLogin)
                    .disposed(by: vm.disposeBag)
            }).disposed(by: disposeBag)
        
        // NAVER Login
        input.tapNaverLoginButton
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                vm.loginUseCase.naverLogin()
                    .bind(to: vm.snsLogin)
                    .disposed(by: vm.disposeBag)
            }).disposed(by: disposeBag)
        
        snsLogin
            .asSignal()
            .withUnretained(self)
            .emit { vm, snsLogin in
                vm.delegate?.reciveData(reseponse: snsLogin)
            }.disposed(by: disposeBag)
        
        snsLogin
            .asSignal()
            .withUnretained(self)
            .emit { vm, snsLogin in
                vm.loginUseCase.reLogin(snsType: snsLogin.snsType,
                                        refreshToken: snsLogin.refreshToken,
                                        authCode: snsLogin.authCode,
                                        idToken: snsLogin.idToken,
                                        state: snsLogin.state,
                                        authorizationCode: snsLogin.authorizationCode)
                .asObservable()
                .bind(to: vm.signUpState)
                .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
            
        signUpState
            .asSignal()
            .withUnretained(self)
            .emit { vm, state in
                switch state {
                case .newbie:
                    vm.controllable?.performTransition(vm, to: .signUp)
                case .solo:
                    vm.controllable?.performTransition(vm, to: .coupleCode)
                    break
                case .couple:
//                    vm.controllable?.performTransition(vm, to: .main)
                    break
                }
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
