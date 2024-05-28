//
//  InquiryViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class InquiryViewModel {
    weak var coordinator: InquiryCoordinator?
    private let useCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    private let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
    private let isDataSubmitEnabled = BehaviorRelay<Bool>(value: false)
    let focusingInputView = PublishRelay<Int>()
    let popUpAlert = PublishRelay<Void>()
    
    struct Input {
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let emailText: ControlProperty<String>
        let tapSubmitButton: ControlEvent<Void>
        let tapCompletionButton: ControlEvent<Void>
        let tapDismissButton: ControlEvent<Void>
        let tapAlertExitButton: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight: BehaviorRelay<CGFloat>
        let isDataSubmitEnabled: BehaviorRelay<Bool>
        let focusingInputView: PublishRelay<Int>
        let popUpAlert: PublishRelay<Void>
    }
    
    init(coordinator: InquiryCoordinator, useCase: ConfigurationUseCase) {
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
                input.titleText.map { $0.count > 0 ? true : false },
                input.contentText.filter { $0 != "페이지 에러, 건의사항, 필로우톡에게 궁금한 점 등 자유롭게 문의 내용을 작성해 주세요 !" }
                    .map { $0.count > 0 ? true : false },
                input.emailText.map { $0.count > 0 ? true : false }
            ) { $0 && $1 && $2 }
            .bind(to: isDataSubmitEnabled)
            .disposed(by: disposeBag)
        
        input.tapCompletionButton
            .withLatestFrom(isDataSubmitEnabled)
            .filter { !$0 }
            .withLatestFrom(focusingInputView)
            .withUnretained(self)
            .bind { vm, count in
                vm.focusingInputView.accept(vm.calculateFocusInputView(with: count))
            }.disposed(by: disposeBag)
                
        Observable
            .merge(
                input.tapSubmitButton.map { true },
                input.tapCompletionButton.withLatestFrom(isDataSubmitEnabled).filter { $0 }
            )
            .withLatestFrom(input.contentText)
            .withLatestFrom(input.emailText) { (body: $0, email: $1) }
            .withLatestFrom(input.titleText) { (title: $1, content: $0) }
            .withUnretained(self)
            .bind(onNext: { vm, data in
                let request = InquiryOrSuggestions(
                    title: data.title,
                    body: data.content.body,
                    email: data.content.email)
                print("Inquiry request: \(request)")
                vm.useCase.comment(with: request)
                    .filter { $0 }
                    .bind { _ in vm.coordinator?.finish() }
            }).disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                input.tapDismissButton.map { true },
                input.titleText,
                input.contentText,
                input.emailText
            ) { $0 && ($1.count + $2.count + $3.count == 0) }
            .filter { $0 == true }
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)

        Observable
            .combineLatest(
                input.tapDismissButton.map { true },
                input.titleText,
                input.contentText,
                input.emailText
            ) { $0 && ($1.count + $2.count + $3.count > 0) }
            .filter { $0 == true }
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
                      isDataSubmitEnabled: self.isDataSubmitEnabled,
                      focusingInputView: self.focusingInputView,
                      popUpAlert: self.popUpAlert)
    }
}

extension InquiryViewModel {
    // TODO: type으로 변경
    
    /// 0: titleInputView
    /// 1: contentInputView
    /// 2: emailInputView
    private func calculateFocusInputView(with count: Int) -> Int {
        return (count + 1) % 3
    }
}
