//
//  AuthConsentViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/12/10.
//

import Foundation
import RxSwift
import RxCocoa

enum AuthConsentButtonType {
    case fullConsent
    case personalInfoConsent
    case serviceConsent
    case uniqueIdentificationInfoConsent
    case newsAgencyUseConsent
}

final class AuthConsentViewModel {
    private weak var coordinator: AuthConsentCoordinator?
    
    /// AdultAuthVM.isConsented 와 연결
    let isConsented = ReplayRelay<Bool>.create(bufferSize: 1)
    private let toggleFullConsent = BehaviorRelay<Bool>(value: false)
    private let togglePersonalInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleServiceConsent = BehaviorRelay<Bool>(value: false)
    private let toggleUniqueIdentificationInfoConsent = BehaviorRelay<Bool>(value: false)
    private let toggleNewsAgencyUseConsent = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let tapFullConsentButton: Observable<Void>
        let tapPersonalInfoConsentButton: Observable<Void>
        let tapServiceConsentButton: Observable<Void>
        let tapUniqueIdentificationInfoConsentButton: Observable<Void>
        let tapNewsAgencyUseConsentButton: Observable<Void>
        let tapNextButton: Observable<Void>
        let dismiss: PublishRelay<Bool>
    }
    
    struct Output {
        let isFullConsentButtonSelected = PublishRelay<Bool>()
        let isPersonalInfoConsentButtonSelected = PublishRelay<Bool>()
        let isServiceConsentButtonSelected = PublishRelay<Bool>()
        let isUniqueIdentificationInfoConsentButtonSelected = PublishRelay<Bool>()
        let isNewsAgencyUseConsentButtonSelected = PublishRelay<Bool>()
        let isNextButtonEnable = PublishRelay<Bool>()
    }
    
    init(coordinator: AuthConsentCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .withLatestFrom(isConsented)
            .withUnretained(self)
            .bind { vm, state in
                output.isFullConsentButtonSelected.accept(state)
                output.isPersonalInfoConsentButtonSelected.accept(state)
                output.isServiceConsentButtonSelected.accept(state)
                output.isUniqueIdentificationInfoConsentButtonSelected.accept(state)
                output.isNewsAgencyUseConsentButtonSelected.accept(state)
                output.isNextButtonEnable.accept(state)
                
                vm.toggleFullConsent.accept(state)
                vm.togglePersonalInfoConsent.accept(state)
                vm.toggleServiceConsent.accept(state)
                vm.toggleUniqueIdentificationInfoConsent.accept(state)
                vm.toggleNewsAgencyUseConsent.accept(state)
            }.disposed(by: disposeBag)
        
        Observable<AuthConsentButtonType>
            .merge(input.tapFullConsentButton.map { .fullConsent },
                   input.tapPersonalInfoConsentButton.map { .personalInfoConsent },
                   input.tapServiceConsentButton.map { .serviceConsent },
                   input.tapUniqueIdentificationInfoConsentButton.map { .uniqueIdentificationInfoConsent },
                   input.tapNewsAgencyUseConsentButton.map { .newsAgencyUseConsent })
            .withUnretained(self)
            .bind { vm, type in
                switch type {
                    
                case .fullConsent:
                    let preValut = vm.toggleFullConsent.value
                    
                    [vm.toggleFullConsent,
                     vm.togglePersonalInfoConsent,
                     vm.toggleServiceConsent,
                     vm.toggleUniqueIdentificationInfoConsent,
                     vm.toggleNewsAgencyUseConsent]
                        .forEach { $0.accept(!preValut) }
                    
                    vm.toggleFullConsent
                        .bind(to: output.isFullConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                    
                    vm.togglePersonalInfoConsent
                        .bind(to: output.isPersonalInfoConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                    
                    vm.toggleServiceConsent
                        .bind(to: output.isServiceConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                    
                    vm.toggleUniqueIdentificationInfoConsent
                        .bind(to: output.isUniqueIdentificationInfoConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                    
                    vm.toggleNewsAgencyUseConsent
                        .bind(to: output.isNewsAgencyUseConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                case .personalInfoConsent:
                    vm.togglePersonalInfoConsent.accept(!vm.togglePersonalInfoConsent.value)
                    
                    vm.togglePersonalInfoConsent
                        .bind(to: output.isPersonalInfoConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                case .serviceConsent:
                    vm.toggleServiceConsent.accept(!vm.toggleServiceConsent.value)
                    
                    vm.toggleServiceConsent
                        .bind(to: output.isServiceConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                case .uniqueIdentificationInfoConsent:
                    vm.toggleUniqueIdentificationInfoConsent.accept(!vm.toggleUniqueIdentificationInfoConsent.value)
                    
                    vm.toggleUniqueIdentificationInfoConsent
                        .bind(to: output.isUniqueIdentificationInfoConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                case .newsAgencyUseConsent:
                    vm.toggleNewsAgencyUseConsent.accept(!vm.toggleNewsAgencyUseConsent.value)
                    
                    vm.toggleNewsAgencyUseConsent
                        .bind(to: output.isNewsAgencyUseConsentButtonSelected)
                        .disposed(by: vm.disposeBag)
                }
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(togglePersonalInfoConsent,
                           toggleServiceConsent,
                           toggleUniqueIdentificationInfoConsent,
                           toggleNewsAgencyUseConsent) { $0 && $1 && $2 && $3 }
            .withUnretained(self)
            .bind { vm, state in
                vm.toggleFullConsent.accept(state)
                output.isNextButtonEnable.accept(state)
            }.disposed(by: disposeBag)
        
        input.tapNextButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        input.dismiss
            .filter { $0 == true }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return output
    }
}
