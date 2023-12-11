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
    private weak var coordinator: LoginCoordinator?
    private let loginUseCase: LoginUseCase
    private let disposeBag = DisposeBag()
    
    private let snsLogin = PublishRelay<SNSLogin01>()

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
                input.tapAppleLoginButton.map { SNSType.apple },
                input.tapGoogleLoginButton.map { SNSType.google },
                input.tapKakaoLoginButton.map { SNSType.kakao },
                input.tapNaverLoginButton.map { SNSType.naver }
            ]).withUnretained(self)
            .bind { vm, snsType in
                switch snsType {
                case .apple:
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
            .withUnretained(self)
            .bind { vm, data in
                vm.loginUseCase.login(data)
                    .bind(onNext: { state in
                        switch state {
                        case .couple:
                            vm.coordinator?.finish()
                        case .newbie:
                            vm.coordinator?.showSignUpFlow()
                        case .solo:
                            vm.coordinator?.showInviteCodeFlow()
                        }
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
