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
    // MARK: Dependencies
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    
    // MARK: Delegate
    weak var controllable: NicknameViewControllable?
    
    init(nicknameControllable: NicknameViewControllable, signUpUseCase: SignUpUseCase) {
        self.controllable = nicknameControllable
        self.signUpUseCase = signUpUseCase
    }
    
    // MARK: ViewModel input stream.
    struct Input {
        let inputNickname: ControlProperty<String>
        let tapNextButton: Observable<SignUp?>
    }
    
    // MARK: ViewModel output stream.
    struct Output {
        let activateNextButton: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
        let preventSpacing: PublishRelay<String> = PublishRelay<String>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 키보드 높이
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { owner, keyboardHeight in
                output.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        // 띄어쓰기 방지
        input.inputNickname
            .asObservable()
            .scan("") { lastValue, newValue in
                let removedSpaceString = newValue.replacingOccurrences(of: " ", with: "")
                return removedSpaceString.count == newValue.count ? newValue : lastValue
            }.bind(to: output.preventSpacing)
            .disposed(by: disposeBag)
        
        // next버튼 활성화
        input.inputNickname
            .map { $0.count > 0 ? true : false }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
//        input.tapNextButton
//            .asObservable()
//            .withLatestFrom(input.inputNickname) { [weak self] signUpInfo, nickname in
//                guard let signUpInfo = signUpInfo,
//                      let self = self else { return }
//                signUpUseCase.signUp(snsType: signUpInfo.snsType,
//                                     nickname: nickname,
//                                     refreshToken: signUpInfo.refreshToken,
//                                     authCode: signUpInfo.authCode,
//                                     idToken: signUpInfo.idToken,
//                                     state: signUpInfo.state,
//                                     authorizationCode: signUpInfo.authorizationCode,
//                                     marketingConsent: signUpInfo.marketingConsent)
//            }.map { _ in nickNameFlow.invietCode }
//            .withUnretained(self)
//            .bind(onNext: { vm, flow in
//                vm.controllable?.performTransition(vm, to: flow)
//            }).disposed(by: disposeBag)
        
//        input.tapNextButton
//            .withUnretained(self)
//            .withLatestFrom(input.inputNickname) { vm, nickname in
//                guard let signUpInfo = vm.1 else { return }
//
//                vm.0.signUpUseCase.signUp(snsType: signUpInfo.snsType,
//                                          nickname: nickname,
//                                          refreshToken: signUpInfo.refreshToken,
//                                          authCode: signUpInfo.authCode,
//                                          idToken: signUpInfo.idToken,
//                                          state: signUpInfo.state,
//                                          authorizationCode: signUpInfo.authorizationCode,
//                                          marketingConsent: signUpInfo.marketingConsent)
//
//                vm.0.controllable?.performTransition(vm.0, to: .invietCode)
//            }.
        
        // 회원가입
        input.tapNextButton
            .withLatestFrom(input.inputNickname) { data, nickname -> SignUp? in
                guard var signUpData = data else { return nil }
                signUpData.nickname = nickname
                
                return signUpData
            }.withUnretained(self)
            .bind { vm, signUp in
                guard let signUp = signUp else { return }
                
                vm.signUpUseCase.signUp(snsType: signUp.snsType,
                                        nickname: signUp.nickname,
                                        refreshToken: signUp.refreshToken,
                                        authCode: signUp.authCode,
                                        idToken: signUp.idToken,
                                        state: signUp.state,
                                        authorizationCode: signUp.authorizationCode,
                                        marketingConsent: signUp.marketingConsent)

                vm.controllable?.performTransition(vm, to: .invietCode)
            }.disposed(by: disposeBag)
        
        return output
    }
}
