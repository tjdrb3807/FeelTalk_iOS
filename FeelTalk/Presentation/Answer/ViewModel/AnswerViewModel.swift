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

import UserNotifications

final class AnswerViewModel {
    private weak var coordinator: AnswerCoordinator?
    private let questionUseCase: QuestionUseCase
    private let disposeBag = DisposeBag()
    var model: Question?
    
    let question = PublishRelay<Question>()
    let keyboardHeight: BehaviorRelay<CGFloat> = BehaviorRelay<CGFloat>(value: 0.0)
    let isActiveAnswerCompletedButton: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let isHiddenAlert = PublishRelay<Bool>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let inputAnswer: ControlProperty<String>
        let tapAnswerCompletedButton: Observable<Question>
        let tapPopButton: ControlEvent<Void>
        let tapAlertLeftButton: ControlEvent<Void>
        let tapAlertRightButton: Observable<AlertType>
    }
    
    struct Output {
        let question: PublishRelay<Question>
        let keyboardHeight: BehaviorRelay<CGFloat>
        let isActiveAnswerCompletedButton: BehaviorRelay<Bool>
        let isHiddenAlert: PublishRelay<Bool>
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
            .compactMap { vm, _ in vm.model }
            .filter { $0.isMyAnswer }
            .withUnretained(self)
            .bind { vm, model in
                model.isMyAnswer ? vm.coordinator?.finish() : vm.isHiddenAlert.accept(false)
            }.disposed(by: disposeBag)
        
        input.tapAlertLeftButton
            .withUnretained(self)
            .map { _ in true }
            .bind(to: isHiddenAlert)
            .disposed(by: disposeBag)
        
        input.tapAlertRightButton
            .withLatestFrom(question) { (type: $0, question: $1) }
            .withLatestFrom(input.inputAnswer) { (model: $0, answer: $1) }
            .withUnretained(self)
            .bind { vm, data in
                if data.model.type == .cancelAnswer {
                    vm.coordinator?.finish()
                } else if  data.model.type == .sendAnswer {
                    vm.questionUseCase.answerQuestion(answer: QuestionAnswer(index: data.model.question.index,
                                                                             myAnswer: data.answer))
                    .filter { $0 == true }
                    .map { _ in Question(index: data.model.question.index,
                                         pageNo: data.model.question.pageNo,
                                         title: data.model.question.title,
                                         header: data.model.question.header,
                                         body: data.model.question.body,
                                         highlight: data.model.question.highlight,
                                         myAnser: data.answer,
                                         partnerAnser: data.model.question.partnerAnser,
                                         isMyAnswer: true,
                                         isPartnerAnswer: data.model.question.isPartnerAnswer,
                                         createAt: data.model.question.createAt)}
                    .bind(to: vm.question)
                    .disposed(by: vm.disposeBag)
                    
                    vm.isHiddenAlert.accept(true)
                }
            }.disposed(by: disposeBag)
            
    
        return Output(question: question,
                      keyboardHeight: self.keyboardHeight,
                      isActiveAnswerCompletedButton: self.isActiveAnswerCompletedButton,
                      isHiddenAlert: self.isHiddenAlert)
    }
}
