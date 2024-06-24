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
    
    let isMarketingConsented = ReplayRelay<Bool>.create(bufferSize: 1)
    let nicknameTextError = BehaviorRelay<NicknameError>(value: .none)
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: NicknameCoordinator, signUpUseCase: SignUpUseCase) {
        self.coodinator  = coordinator
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let nicknameText: Observable<String>
        let tapNextButton: ControlEvent<Void>
        let tapNavigationBarLeftButton: ControlEvent<Void>
    }
    
    struct Output {
        let activateNextButton: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
        let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
        let nicknameTextError = PublishRelay<NicknameError>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        nicknameTextError
            .bind(to: output.nicknameTextError)
            .disposed(by: disposeBag)
        
        // 키보드 높이
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { owner, keyboardHeight in
                output.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.nicknameText
            .map { $0.count }
            .filter { $0 > 10 }
            .map { _ in NicknameError.moreNumberOfChar }
            .bind(to: output.nicknameTextError)
            .disposed(by: disposeBag)
        
        // 특수문자, 띄어쓰기 방지 정규식
        input.nicknameText
            .map { text in
                let pattern = "^[0-9a-zㅏ-ㅣA-Zㄱ-ㅎ가-핳]*$"
                
                guard let _ = text.range(of: pattern, options: .regularExpression) else { return NicknameError.ignoreRegularExpression }
                
                return NicknameError.none
            }.distinctUntilChanged()
            .bind(to: nicknameTextError)
            .disposed(by: disposeBag)
            
        // next버튼 활성화
        input.nicknameText
            .map { $0.count > 0 ? true : false }
            .withLatestFrom(nicknameTextError) { $1 != .none ? false : $0 }
            .bind(to: output.activateNextButton)
            .disposed(by: disposeBag)
        
        input.tapNextButton
            .withLatestFrom(isMarketingConsented)
            .withLatestFrom(input.nicknameText) { SignUpInfo(nickname: $1, marketingConsent: $0) }
            .withUnretained(self)
            .bind { vm, model in
                vm.signUpUseCase.signUp(model)
                    .filter { $0 }
                    .bind { _ in
                        KeychainRepository.addItem(value: UserState.solo.rawValue, key: "userState")
                        vm.coodinator?.finish()                        
                    }.disposed(by: vm.disposeBag)
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
