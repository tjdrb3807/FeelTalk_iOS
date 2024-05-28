//
//  SuggestionsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/26.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class SuggestionsViewModel {
    weak var coordinator: SuggestionsCoordinator?
    private let useCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
    private let isValid = BehaviorRelay<Bool>(value: false)
    private let focusingInputView = PublishRelay<Int>()
    private let isSubmit = BehaviorRelay<Bool>(value: false)
    let popUpAlert = PublishRelay<Void>()
    
    struct Input {
        let ideaText: ControlProperty<String>
        let ideaTextCount: Observable<Int>
        let emailText: ControlProperty<String>
        let tapSubmitButton: ControlEvent<Void>
        let tapCompletionButton: ControlEvent<Void>
        let tapDismissButton: ControlEvent<Void>
        let tapAlertExitButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat>
        let isValid: Observable<Bool>
        let focusingInputView: PublishRelay<Int>
        let popUpAlert: PublishRelay<Void>
    }
    
    init(coordinator: SuggestionsCoordinator, useCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    func transfer(input: Input) -> Output {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                vm.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                input.ideaTextCount.map { $0 > 0 ? true : false },
                input.emailText.map { $0.count > 0 ? true : false }
            ) { $0 && $1 }
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
        input.tapCompletionButton
            .withLatestFrom(isValid)
            .filter { !$0 }
            .withLatestFrom(input.ideaTextCount)
            .withUnretained(self)
            .bind { vm, count in
                vm.focusingInputView.accept(vm.calculateFocusInputView(with: count))
            }.disposed(by: disposeBag)
            
        Observable
            .merge(input.tapSubmitButton.map { true },
                   input.tapCompletionButton.withLatestFrom(isValid).filter { $0 })
            .withLatestFrom(input.ideaText)
            .withLatestFrom(input.emailText) { (idea: $0, email: $1) }
            .withUnretained(self)
            .bind { vm, data in
                vm.useCase.comment(with: InquiryOrSuggestions(title: data.idea,
                                                               body: nil,
                                                               email: data.email))
                .filter { $0 }
                .bind { _ in vm.coordinator?.finish() }
            }.disposed(by: disposeBag)
        
        input.tapDismissButton
            .withLatestFrom(input.ideaTextCount)
            .withLatestFrom(input.emailText) { (ideaTextCount: $0, emailTextCount: $1.count) }
            .filter { $0.ideaTextCount + $0.emailTextCount == 0 }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        input.tapDismissButton
            .withLatestFrom(input.ideaTextCount)
            .withLatestFrom(input.emailText) { (ideaTextCount: $0, emailTextCount: $1.count) }
            .filter { $0.ideaTextCount + $0.emailTextCount > 0 }
            .withUnretained(self)
            .bind { vm, _ in
                vm.popUpAlert.accept(())
            }.disposed(by: disposeBag)
        
        input.tapAlertExitButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
            
        return Output(keyboardHeight: self.keyboardHeight,
                      isValid: self.isValid.asObservable(),
                      focusingInputView: self.focusingInputView,
                      popUpAlert: self.popUpAlert)
    }
}

extension SuggestionsViewModel {
    // TODO: type으로 변경
    /// 0: ideaInputView
    /// 1: emailInputView
    private func calculateFocusInputView(with count: Int) -> Int {
        count == 0 ? 0 : 1
    }
}
