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

class NicknameViewModel {
    // MARK: Dependencies
    private weak var coodinator: NicknameCoordinator?
    private let signUpUseCase: SignUpUseCase
    private let disposeBag = DisposeBag()
    private var signUp: SignUp
    
    init(coordinator: NicknameCoordinator,
         signUpUseCase: SignUpUseCase,
         signUp: SignUp) {
        self.coodinator  = coordinator
        self.signUpUseCase = signUpUseCase
        self.signUp = signUp
    }
    
    // MARK: ViewModel input stream.
    struct Input {
        let inputNickname: ControlProperty<String>
        let tapNextButton: ControlEvent<Void>
        let tapNavigationBarLeftButton: ControlEvent<Void>
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
        
        // 회원가입
        input.tapNextButton
            .withUnretained(self)
            .withLatestFrom(input.inputNickname) { vm, nickname -> SignUp in
                vm.0.signUp.nickname = nickname

                return vm.0.signUp
            }.withUnretained(self)
            .map { vm, signUp -> Void in
                vm.signUpUseCase.signUp(snsType: vm.signUp.snsType,
                                        nickname: vm.signUp.nickname,
                                        refreshToken: vm.signUp.refreshToken,
                                        authCode: vm.signUp.authCode,
                                        idToken: vm.signUp.idToken,
                                        state: vm.signUp.state,
                                        authorizationCode: vm.signUp.authorizationCode,
                                        marketingConsent: vm.signUp.marketingConsent)
            }.withUnretained(self)
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind { vm, _ in
                vm.coodinator?.showInviteCodeFlow()
            }.disposed(by: disposeBag)
        
        input.tapNavigationBarLeftButton
            .asObservable()
            .withUnretained(self)
            .bind(onNext: { vm, _ in
                vm.coodinator?.popViewController()
            }).disposed(by: disposeBag)
        
        return output
    }
}
