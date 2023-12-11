//
//  SignUpViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/12.
//

import Foundation
import RxSwift
import RxCocoa

enum ConsentButtonType {
    case fullConsent
    case serviceConsent
    case personalInfoConsent
    case sensitiveInfoConsent
    case marketingInfoConsent
}

final class SignUpViewModel {
    private weak var coordinator: SignUpCoordinator?
    private let signUpUseCase: SignUpUseCase
    private let dispoasBag = DisposeBag()

    private let adultAuthenticated = BehaviorRelay<AdultAuthStatus>(value: .nonAuthenticated)
    private let consentButtonTapped = PublishRelay<ConsentButtonType>()
    private let toggleFullConsent = BehaviorRelay<Bool>(value: false)
    private let toggleServiceConsent = BehaviorRelay<Bool>(value: false)
    private let togglePersonalInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleSensitiveInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleMarketingInfoConsent = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let tapAuthButton: Observable<Void>
        let tapNextButton: Observable<Void>
        let tapFullSelectionButton: Observable<Void>
        let tapServiceConsentButton: Observable<Void>
        let tapPersonalInfoConsentButton: Observable<Void>
        let tapSensitiveInfoConsentButton: Observable<Void>
        let tapMarketingInfoConsentButton: Observable<Void>
        let tapPopButton: Observable<Void>
    }
    
    struct Output {
        let adultAuthenticated = BehaviorRelay<AdultAuthStatus>(value: .nonAuthenticated)
        let isFullConsentSeleted = BehaviorRelay<Bool>(value: false)
        let isServiceConsentSeleted = PublishRelay<Bool>()
        let isPersonalInfoConsentSeleted = PublishRelay<Bool>()
        let isSensitiveInfoConsentSelected = PublishRelay<Bool>()
        let isMarketingInfoConsentSelected = PublishRelay<Bool>()
        let isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    }
    
    init(coordinator: SignUpCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        adultAuthenticated
            .bind(to: output.adultAuthenticated)
            .disposed(by: dispoasBag)
        
        input.tapAuthButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showAdultAuthFlow()
            }.disposed(by: dispoasBag)
        
        Observable<ConsentButtonType>
            .merge([
                input.tapFullSelectionButton.map { _ in .fullConsent },
                input.tapServiceConsentButton.map { _ in .serviceConsent },
                input.tapPersonalInfoConsentButton.map { _ in .personalInfoConsent },
                input.tapSensitiveInfoConsentButton.map { _ in .sensitiveInfoConsent },
                input.tapMarketingInfoConsentButton.map { _ in .marketingInfoConsent }
            ]).bind(to: consentButtonTapped)
            .disposed(by: dispoasBag)
        
        consentButtonTapped
            .withUnretained(self)
            .bind { vm, type in
                switch type {
                case .fullConsent:
                    let preValue = vm.toggleFullConsent.value
                    
                    [vm.toggleFullConsent,
                     vm.toggleServiceConsent,
                     vm.togglePersonalInfoConsent,
                     vm.toggleSensitiveInfoConsent,
                     vm.toggleMarketingInfoConsent]
                        .forEach { $0.accept(!preValue) }
                    
                    vm.toggleFullConsent
                        .bind(to: output.isFullConsentSeleted)
                        .disposed(by: vm.dispoasBag)
                    
                    vm.toggleServiceConsent
                        .bind(to: output.isServiceConsentSeleted)
                        .disposed(by: vm.dispoasBag)
                    
                    vm.togglePersonalInfoConsent
                        .bind(to: output.isPersonalInfoConsentSeleted)
                        .disposed(by: vm.dispoasBag)
                    
                    vm.toggleSensitiveInfoConsent
                        .bind(to: output.isSensitiveInfoConsentSelected)
                        .disposed(by: vm.dispoasBag)
                    
                    vm.toggleMarketingInfoConsent
                        .bind(to: output.isMarketingInfoConsentSelected)
                        .disposed(by: vm.dispoasBag)
                case .serviceConsent:
                    vm.toggleServiceConsent.accept(!vm.toggleServiceConsent.value)
                    vm.toggleServiceConsent
                        .bind(to: output.isServiceConsentSeleted)
                        .disposed(by: vm.dispoasBag)
                case .personalInfoConsent:
                    vm.togglePersonalInfoConsent.accept(!vm.togglePersonalInfoConsent.value)
                    vm.togglePersonalInfoConsent
                        .bind(to: output.isPersonalInfoConsentSeleted)
                        .disposed(by: vm.dispoasBag)
                case .sensitiveInfoConsent:
                    vm.toggleSensitiveInfoConsent.accept(!vm.toggleSensitiveInfoConsent.value)
                    vm.toggleSensitiveInfoConsent
                        .bind(to: output.isSensitiveInfoConsentSelected)
                        .disposed(by: vm.dispoasBag)
                case .marketingInfoConsent:
                    vm.toggleMarketingInfoConsent.accept(!vm.toggleMarketingInfoConsent.value)
                    vm.toggleMarketingInfoConsent
                        .bind(to: output.isMarketingInfoConsentSelected)
                        .disposed(by: vm.dispoasBag)
                }
            }.disposed(by: dispoasBag)
        
        Observable
            .combineLatest(toggleServiceConsent,
                           togglePersonalInfoConsent,
                           toggleSensitiveInfoConsent,
                           toggleMarketingInfoConsent) { $0 && $1 && $2 && $3 }
            .bind(to: toggleFullConsent)
            .disposed(by: dispoasBag)
        
        Observable.combineLatest(toggleServiceConsent,
                                 togglePersonalInfoConsent,
                                 toggleSensitiveInfoConsent) { $0 && $1 && $2 }
            .bind(to: output.isNextButtonEnabled)
            .disposed(by: dispoasBag)
        //
        //        input.tapNextButton
        //            .withUnretained(self)
        //            .withLatestFrom(toggleMarketingInfoConsent) { vm, state -> SignUp in
        //                return SignUp(snsType: vm.0.snsLogin.snsType,
        //                              nickname: "",
        //                              refreshToken: vm.0.snsLogin.refreshToken,
        //                              authCode: vm.0.snsLogin.authCode,
        //                              idToken: vm.0.snsLogin.idToken,
        //                              authorizationCode: vm.0.snsLogin.authCode,
        //                              marketingConsent: state)
        //            }.withUnretained(self)
        //            .bind { vm, signUp in
        //                vm.coordinator?.showNicknameFlow(with: signUp)
        //            }.disposed(by: dispoasBag)
        
        input.tapPopButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: dispoasBag)
        
        return output
        
    }
}
