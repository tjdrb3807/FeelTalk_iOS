//
//  AnswerViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class AnswerViewModel {
    private weak var coordinator: AnswerCoordinator?
    private let questionUseCase: QuestionUseCase
    private let disposeBag = DisposeBag()
    var model: Question?
    
    let question = PublishRelay<Question>()
    let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
    let isActiveAnswerCompletedButton: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let inputAnswer: ControlProperty<String>
        let tapAnswerCompletedButton: ControlEvent<Void>
        let tapPopButton: ControlEvent<Void>
    }
    
    struct Output {
        let question: PublishRelay<Question>
        let keyboardHeight: BehaviorRelay<CGFloat>
        let isActiveAnswerCompletedButton: BehaviorRelay<Bool>
    }
    
    init(coordinator: AnswerCoordinator, questionUseCase: QuestionUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
    }
    
    func transfer(input: Input) -> Output {
        // 키보드 높이
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .withUnretained(self)
            .bind { vm, keyboardHeight in
                vm.keyboardHeight.accept(keyboardHeight)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .compactMap { vm, _ in vm.model }
            .bind(to: question)
            .disposed(by: disposeBag)
        
        // answerCompletedButton 활성화
        input.inputAnswer
            .map { text -> Bool in
                text == MyAnswerViewNameSpace.answerTextViewPlaceHolderText || text == "" ? false : true
            }.bind(to: isActiveAnswerCompletedButton)
            .disposed(by: disposeBag)
        
        input.tapPopButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
//        input.tapAnswerCompletedButton
//            .withLatestFrom(input.inputAnswer)
//            .withUnretained(self)
//            .bind { vm, text in
//                guard let index = vm.index else { return }
//                let model = QuestionAnswer(index: index, myAnswer: text)
//                vm.questionUseCase.answerQuestion(answer: model)
//            }.disposed(by: disposeBag)
        
        return Output(question: question,
                      keyboardHeight: self.keyboardHeight,
                      isActiveAnswerCompletedButton: self.isActiveAnswerCompletedButton)
    }
}
