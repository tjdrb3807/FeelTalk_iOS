//
//  LoginViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/07.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    // Dependencies
    private weak var coordinator: LoginCoordinator?
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    // Stream
    private let snsLogin = PublishRelay<SNSLogin>()

    struct Input {
        let tapAppleLoginButton: ControlEvent<Void>
        let tapGoogleLoginButton: ControlEvent<Void>
        let tapKakaoLoginButton: ControlEvent<Void>
        let tapNaverLoginButton: ControlEvent<Void>
    }
    
    struct Output { }

    init(coordinator: LoginCoordinator?, loginUseCase: LoginUseCase) {
        self.coordinator = coordinator
        self.loginUseCase = loginUseCase
    }
    
    func transfer(input: Input) -> Output {
        Observable
            .merge([
                input.tapAppleLoginButton.map { SNSType.appleIOS },
                input.tapGoogleLoginButton.map { SNSType.google },
                input.tapKakaoLoginButton.map { SNSType.kakao },
                input.tapNaverLoginButton.map { SNSType.naver }
            ]).withUnretained(self)
            .bind { vm, snsType in
                switch snsType {
                case .appleIOS:
                    vm.loginUseCase.appleLogin()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .google:
                    vm.loginUseCase.googleLogin()
                        .asObservable()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .kakao:
                    vm.loginUseCase.kakaoLogin()
                        .asObservable()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                case .naver:
                    vm.loginUseCase.naverLogin()
                        .bind(to: vm.snsLogin)
                        .disposed(by: vm.disposeBag)
                }
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
                                        authorizationCode: snsLogin.authCode)
                .asObservable()
                .withUnretained(self)
                .bind { vm, state in
                    switch state {
                    case .newbie:
                        vm.coordinator?.showSignUpFlow(with: snsLogin)
                    case .solo:
                        break
                    case .couple:
                        break
                    }
                }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
