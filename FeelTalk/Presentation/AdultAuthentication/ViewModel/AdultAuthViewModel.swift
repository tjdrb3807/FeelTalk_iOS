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

enum AdultAuthNumberRequestState {
    case none
    case requested
}

final class AdultAuthViewModel {
    private var timer = Timer()
    
    private weak var coordinator: AdultAuthCoordinator?
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    
    let userName = BehaviorRelay<String>(value: "")
    let userBirthday = BehaviorRelay<String>(value: "")
    let userGenderNumber = BehaviorRelay<String>(value: "")
    let selectedNewsAgnecy = BehaviorRelay<NewsAgencyType>(value: .skt)
    let userPhoneNumber = BehaviorRelay<String>(value: "")
    let preUserInfo = BehaviorRelay<UserAuthInfo>(value: UserAuthInfo())
    let isConsented = BehaviorRelay<Bool>(value: false) // 약관 동의 상태
    let expiradTime = PublishRelay<String>()  // 인증 만료 시간
    let isAuthenticated = PublishRelay<Bool>()  // 인증 결과
    
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
        let focusedInputView = PublishRelay<AdultAuthFocusedInputView>()
        let popAlert = PublishRelay<Void>()
        let authDescriptionState = BehaviorRelay<AdultAuthNumberDescription>(value: .base)
        let expiradTime = PublishRelay<String>()
        let isRequested = BehaviorRelay<AdultAuthNumberRequestState>(value: .none) // 인증 요청 상태
        let isAuthNumberInputViewEnable = BehaviorRelay<Bool>(value: false)
        let sessionUuid = BehaviorRelay<String>(value: "")
    }
    
    init(coordiantor: AdultAuthCoordinator, signUpUseCase: SignUpUseCase) {
        self.coordinator =  coordiantor
        self.signUpUseCase = signUpUseCase
    }
    
    deinit { timer.invalidate() }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        // AuthNumberInputView 활성화 상태
        // 모든 inputView가 비어있지 않으며, 약관을 동의한 상태일때 'TRUE' 이벤트 방출 else "FALSE' 이벤트 방출
        Observable
            .combineLatest(userName,
                           userBirthday,
                           userGenderNumber,
                           userPhoneNumber,
                           isConsented) { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3.isEmpty && $4 }
            .distinctUntilChanged()
            .bind(to: output.isAuthNumberInputViewEnable)
            .disposed(by: disposeBag)
        
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
        
        isConsented
            .filter { $0 == true }
            .bind(to: output.isWarningViewHidden)
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
        
//        input.tapAuthButton
//            .withLatestFrom(output.isRequested)
//            .withUnretained(self)
//            .bind { vm, isRequested in
//                
//            }.disposed(by: disposeBag)
        
        input.tapAuthButton
            .withLatestFrom(output.isRequested)
            .withUnretained(self)
            .bind { vm, isRequested in
                if vm.userName.value.isEmpty {
                    output.focusedInputView.accept(.name)
                    return
                } else if vm.userBirthday.value.isEmpty {
                    output.focusedInputView.accept(.birthday)
                    return
                } else if vm.userGenderNumber.value.isEmpty {
                    output.focusedInputView.accept(.genderNumber)
                    return
                } else if vm.userPhoneNumber.value.isEmpty {
                    output.focusedInputView.accept(.phoneNumber)
                    return
                } else if vm.isConsented.value == false {
                    output.isWarningViewHidden.accept(false)
                    return
                }
                
                let model = UserAuthInfo(name: vm.userName.value,
                                         birthday: vm.userBirthday.value,
                                         genderNumber: vm.userGenderNumber.value,
                                         newsAgency: vm.selectedNewsAgnecy.value,
                                         phoneNumber: vm.userPhoneNumber.value)
                
                switch isRequested {
                case .none: // 인증 요청을 하지 않은 경우
                    vm.signUpUseCase.getAuthNumber(model)
                        .bind { result in
                            if !result.isEmpty {
                                vm.setTimer(with: 180)    // 인증 만료시간 설정(3m)
                                output.authDescriptionState.accept(.base)
                                output.isRequested.accept(.requested)
                                output.sessionUuid.accept(result)
                                vm.preUserInfo.accept(model)
                            } else {
                                output.popAlert.accept(())
                            }
                        }.disposed(by: vm.disposeBag)
                case .requested:    // 인증 요청을 한 경우
                    let preValue = vm.preUserInfo.value
                    
                    if preValue ==  model { // 이전 사용자 정보가 같은 경우(재요청)
                        vm.signUpUseCase.getReAuthNumber(output.sessionUuid.value)
                            .bind { result in
                                if result {
                                    vm.setTimer(with: 180)
                                    output.authDescriptionState.accept(.base)
                                    output.isRequested.accept(.requested)
                                    vm.preUserInfo.accept(model)
                                }
                            }.disposed(by: vm.disposeBag)
                    } else {    // 이전 사용자 정보와 다른 경우(새로 요청)
                        vm.signUpUseCase.getAuthNumber(model)
                            .bind { result in
                                if !result.isEmpty {
                                    vm.setTimer(with: 180)    // 인증 만료시간 설정(3m)
                                    output.authDescriptionState.accept(.base)
                                    output.isRequested.accept(.requested)
                                    output.sessionUuid.accept(result)
                                    vm.preUserInfo.accept(model)
                                } else {
                                    output.popAlert.accept(())
                                }
                            }.disposed(by: vm.disposeBag)
                    }
                }
                
            }.disposed(by: disposeBag)
        
        expiradTime
            .bind(to: output.expiradTime)
            .disposed(by: disposeBag)
        
        input.tapCompleteButton
            .withLatestFrom(expiradTime)
            .map { $0 == "00:00" ? false : true }
            .withLatestFrom(input.inputAuthNumber) { (state: $0, authNumber: $1) }
            .withUnretained(self)
            .bind { vm, event in
                if event.state {
                    vm.signUpUseCase.verifyAnAdult(authNumber: event.authNumber, sessionUuid: output.sessionUuid.value)
                        .bind(to: vm.isAuthenticated)
                        .disposed(by: vm.disposeBag)
                } else {
                    output.authDescriptionState.accept(.expirad)
                }
            }.disposed(by: disposeBag)
        
        isAuthenticated
            .withUnretained(self)
            .bind { vm, result in
                if result {
                    vm.coordinator?.finish()
                } else {
                    output.authDescriptionState.accept(.mismatch)
                }
            }.disposed(by: disposeBag)
        
        input.tapDismissButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return output
    }
}

extension AdultAuthViewModel {
    private func setTimer(with countDownSeconds: Double) {
        let startTime = Date()
        
        timer.invalidate() // 기존 타이머 삭제
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true,
                                     block: { [weak self] timer in
            guard let self = self else { return }
            
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
            let remainSeconds = Int(countDownSeconds) - elapsedTimeSeconds
            
            guard remainSeconds >= 0 else {
                timer.invalidate()
                
                return
            }
            
            self.expiradTime.accept(String(format: "%02d:%02d",
                                      Int(remainSeconds / 60),
                                      Int(remainSeconds % 60)))
        })
    }
}

