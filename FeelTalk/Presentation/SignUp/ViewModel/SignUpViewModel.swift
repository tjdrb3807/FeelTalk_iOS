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
    case totalConsent
    case serviceConsent
    case personalInfoConsent
    case sensitiveInfoConsent
    case marketingInfoConsent
}

protocol SignUpViewControllable: AnyObject {
    func performTransition(_ signUpViewModel: SignUpViewModel, to transition: SignUpFlow)
}

protocol SendSignUpInfoDataDelegate: AnyObject {
    func reciveData(response: SignUpInfo)
}

final class SignUpViewModel {
    private let signUpUseCase: SignUpUseCase
    private let dispoasBag = DisposeBag()
    
    weak var controllable: SignUpViewControllable?
    weak var delegate: SendSignUpInfoDataDelegate?
    
    private let isAdultAuth = BehaviorRelay<Bool>(value: false)
    private let snsLogin = PublishSubject<SNSLogin?>()
    private let consentButtonTapped = PublishRelay<ConsentButtonType>()
    private let toggleTotalConsent = BehaviorRelay<Bool>(value: false)
    private let toggleServiceConsent = BehaviorRelay<Bool>(value: false)
    private let togglePersonalInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleSensitiveInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleMarketingInfoConsent = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let tapAuthButton: Observable<SNSLogin?>
        let tapNextButton: ControlEvent<Void>
        let tapTotalConsentButton: ControlEvent<Void>
        let tapServiceConsentButton: ControlEvent<Void>
        let tapPersonalInfoConsentButton: ControlEvent<Void>
        let tapSensitiveInfoConsentButton: ControlEvent<Void>
        let tapMarketingInfoConsentButton: ControlEvent<Void>
    }
    
    struct Output {
        let setInfoConsentUI: PublishRelay<Bool> = PublishRelay<Bool>()
        let totalConsentIsSelected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        let serviceConsentIsSelected: PublishSubject<Bool> = PublishSubject<Bool>()
        let personalInfoConsentIsSelected: PublishSubject<Bool> = PublishSubject<Bool>()
        let sensitiveInfoConsentIsSelected: PublishSubject<Bool> = PublishSubject<Bool>()
        let marketingInfoConsentIsSelected: PublishSubject<Bool> = PublishSubject<Bool>()
        let nextButtonIsEnable: PublishSubject<Bool> = PublishSubject<Bool>()
    }
    
    init(signUpControllable: SignUpViewControllable, delegate: SendSignUpInfoDataDelegate, signUpUseCase: SignUpUseCase) {
        self.controllable = signUpControllable
        self.delegate = delegate
        self.signUpUseCase = signUpUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.tapAuthButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                // TODO: PASS 성인인증 기능 구현
                Observable.create { observer -> Disposable in
                    observer.onNext(true)
                    return Disposables.create()
                }.bind(to: owner.isAdultAuth)
                    .disposed(by: owner.dispoasBag)
            }).disposed(by: dispoasBag)
        
        input.tapAuthButton
            .bind(to: snsLogin)
            .disposed(by: dispoasBag)
        
        Observable<ConsentButtonType>
            .merge([
                input.tapTotalConsentButton.map { _ in .totalConsent },
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
                case .totalConsent:
                    let preValue = vm.toggleTotalConsent.value
                    // TODO: UI 작업 요청
                    vm.toggleTotalConsent
                        .bind(to: output.totalConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                    [vm.toggleTotalConsent,
                     vm.toggleServiceConsent,
                     vm.togglePersonalInfoConsent,
                     vm.toggleSensitiveInfoConsent,
                     vm.toggleMarketingInfoConsent]
                        .forEach { $0.accept(!preValue) }
                    
                    vm.toggleServiceConsent
                        .bind(to: output.serviceConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                    vm.togglePersonalInfoConsent
                        .bind(to: output.personalInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                    vm.toggleSensitiveInfoConsent
                        .bind(to: output.sensitiveInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                    vm.toggleMarketingInfoConsent
                        .bind(to: output.marketingInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                    
                case .serviceConsent:
                    vm.toggleServiceConsent.accept(!vm.toggleServiceConsent.value)
                    vm.toggleServiceConsent
                        .bind(to: output.serviceConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                case .personalInfoConsent:
                    vm.togglePersonalInfoConsent.accept(!vm.togglePersonalInfoConsent.value)
                    vm.togglePersonalInfoConsent
                        .bind(to: output.personalInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                case .sensitiveInfoConsent:
                    vm.toggleSensitiveInfoConsent.accept(!vm.toggleSensitiveInfoConsent.value)
                    vm.toggleSensitiveInfoConsent
                        .bind(to: output.sensitiveInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                case .marketingInfoConsent:
                    vm.toggleMarketingInfoConsent.accept(!vm.toggleMarketingInfoConsent.value)
                    vm.toggleMarketingInfoConsent
                        .bind(to: output.marketingInfoConsentIsSelected)
                        .disposed(by: vm.dispoasBag)
                }
            }.disposed(by: dispoasBag)
        
        Observable
            .combineLatest(toggleServiceConsent,
                           togglePersonalInfoConsent,
                           toggleSensitiveInfoConsent,
                           toggleMarketingInfoConsent) { $0 && $1 && $2 && $3 }
            .bind(to: toggleTotalConsent)
            .disposed(by: dispoasBag)
        
        Observable.combineLatest(
            toggleServiceConsent,
            togglePersonalInfoConsent,
            toggleSensitiveInfoConsent) { $0 && $1 && $2 }
            .bind(to: output.nextButtonIsEnable)
            .disposed(by: dispoasBag)
        
        input.tapNextButton
            .withLatestFrom(snsLogin) { $1! }
            .withUnretained(toggleMarketingInfoConsent) { state, snsLogin -> SignUpInfo in
                return SignUpInfo(snsType: snsLogin.snsType,
                                  refreshToken: snsLogin.refreshToken,
                                  authCode: snsLogin.authCode,
                                  idToken: snsLogin.idToken,
                                  authorizationCode: snsLogin.authorizationCode,
                                  marketingConsent: state.value)}
            .withUnretained(self)
            .bind { vm, signUpInfo in
                vm.delegate?.reciveData(response: signUpInfo)
                vm.controllable?.performTransition(vm, to: .nickname)
            }.disposed(by: dispoasBag)
        
        isAdultAuth
            .filter { _ in true }
            .bind(to: output.setInfoConsentUI)
            .disposed(by: dispoasBag)
        
        return output
    }
}
