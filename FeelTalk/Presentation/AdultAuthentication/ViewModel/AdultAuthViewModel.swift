//
//  AdultAuthViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class AdultAuthViewModel {
    private weak var coordinator: AdultAuthCoordinator?
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    
    let userName = BehaviorRelay<String>(value: "")
    let userBirthday = BehaviorRelay<String>(value: "")
    let userGenderNumber = BehaviorRelay<String>(value: "")
    let selectedNewsAgnecy = BehaviorRelay<NewsAgencyType>(value: .skt)
    let userPhoneNumber = BehaviorRelay<String>(value: "")
    let isConsented = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let inputName: Observable<String>
        let inputBirthday: Observable<String>
        let inputGenderNumber: Observable<String>
        let tapNewsAgencyButton: Observable<Void>
        let inputPhoneNumber: Observable<String>
        let tapConsentButton: Observable<Void>
        let inputAuthNumber: Observable<String>
        let tapAuthButton: Observable<Void>
        let tapCompleteButton: Observable<Void>
        let tapDismissButton: Observable<Void>
    }
    
    struct Output {
        let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
        let selectedNewsAgency = BehaviorRelay<NewsAgencyType>(value: .skt)
        let isConsented = BehaviorRelay<Bool>(value: false)
        let isWarningViewHidden = BehaviorRelay<Bool>(value: true)
    }
    
    init(coordiantor: AdultAuthCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator =  coordiantor
        self.signUpUseCase = signUpUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        RxKeyboard
            .instance
            .visibleHeight
            .asObservable()
            .filter { 0.0 <= $0 }
            .bind { height in
                output.keyboardHeight.accept(height)
            }.disposed(by: disposeBag)
            
        selectedNewsAgnecy
            .bind(to: output.selectedNewsAgency)
            .disposed(by: disposeBag)
        
        isConsented
            .bind(to: output.isConsented)
            .disposed(by: disposeBag)
        
        input.inputName
            .bind(to: userName)
            .disposed(by: disposeBag)
        
        input.inputBirthday
            .bind(to: userBirthday)
            .disposed(by: disposeBag)
        
        input.inputGenderNumber
            .bind(to: userGenderNumber)
            .disposed(by: disposeBag)
        
        input.tapNewsAgencyButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showNewsAgencyFlow()
            }.disposed(by: disposeBag)
        
        input.inputPhoneNumber
            .bind(to: userPhoneNumber)
            .disposed(by: disposeBag)
        
        input.tapConsentButton
            .withLatestFrom(isConsented)
            .withUnretained(self)
            .bind { vm, state in
                vm.coordinator?.showAuthConsentFlow()
                vm.coordinator?.isFullConsented.accept(state)
            }.disposed(by: disposeBag)
        
        input.tapAuthButton
            .withLatestFrom(isConsented)
            .withUnretained(self)
            .bind { vm, state in
                if state {
                    vm.signUpUseCase.getAuthNumber(UserAuthInfo(name: vm.userName.value,
                                                                birthday: vm.userBirthday.value,
                                                                genderNumber: vm.userGenderNumber.value,
                                                                newsAgency: vm.selectedNewsAgnecy.value,
                                                                phoneNumber: vm.userPhoneNumber.value))
                    .filter { $0 == true }
                    .bind(onNext: {
                        print($0)
                        print("시계 동작")
                    }).disposed(by: vm.disposeBag)
                } else {
                    output.isWarningViewHidden.accept(state)
                }
            }.disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(input.inputAuthNumber)
            .withUnretained(self)
            .bind { vm, number in
                
            }.disposed(by: disposeBag)
        
        input.tapDismissButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return output
    }
}
