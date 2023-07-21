//
//  UserNicknameViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/06/09.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

protocol NicknameViewControllable: AnyObject {
    func performTransition(_ nicknameViewModel: NicknameViewModel, to transition: nickNameFlow)
}

class NicknameViewModel {
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    
    weak var controllable: NicknameViewControllable?
    
    init(nicknameControllable: NicknameViewControllable, signUpUseCase: SignUpUseCase) {
        self.controllable = nicknameControllable
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let inputNickname: ControlProperty<String>
        let tapNextButton: Observable<SignUpInfo?>
    }
    
    struct Output {
        let activateNextButton: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
        let preventSpacing: PublishRelay<String> = PublishRelay<String>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { owner, keyboardHeight in
                output.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.inputNickname
            .asObservable()
            .scan("") { lastValue, newValue in
                let removedSpaceString = newValue.replacingOccurrences(of: " ", with: "")
                return removedSpaceString.count == newValue.count ? newValue : lastValue
            }.bind(to: output.preventSpacing)
            .disposed(by: disposeBag)
        
        input.inputNickname
            .map { $0.count > 0 ? true : false }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
        input.tapNextButton
            .withLatestFrom(input.inputNickname) { [weak self] signUpInfo, nickname in
                guard let signUpInfo = signUpInfo,
                      let self = self else { return }
                signUpUseCase.signUp(snsType: signUpInfo.snsType,
                                     nickname: nickname,
                                     refreshToken: signUpInfo.refreshToken,
                                     authCode: signUpInfo.authCode,
                                     idToken: signUpInfo.idToken,
                                     state: signUpInfo.state,
                                     authorizationCode: signUpInfo.authorizationCode,
                                     marketingConsent: signUpInfo.marketingConsent)
            }.map { _ in nickNameFlow.invietCode }
            .withUnretained(self)
            .bind(onNext: { vm, flow in
                vm.controllable?.performTransition(vm, to: flow)
            }).disposed(by: disposeBag)
        
            
            
        
        return output
    }
}
