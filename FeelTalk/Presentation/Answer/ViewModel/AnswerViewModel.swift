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
    private let userUserCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    let model = ReplayRelay<Question>.create(bufferSize: 1)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let myAnswerObserver: ControlProperty<String>
        let tapPressForAnswerButton: ControlEvent<Void>
        let tapPopButton: ControlEvent<Void>
        let tapAlertRightButton: Observable<CustomAlertType>
        let tapAnswerCompletedButton: ControlEvent<Void>
    }
    
    struct Output {
        let model = PublishRelay<Question>()
        let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
        let isActiveAnswerCompletedButton = BehaviorRelay<Bool>(value: false)
        let bottomSheetHiddenObserver = PublishRelay<Void>()
        let popUpAlertObserver = PublishRelay<CustomAlertType>()
        let popUpPressForAnswerToastMessage = PublishRelay<String>()
    }
    
    init(coordinator: AnswerCoordinator, questionUseCase: QuestionUseCase, userUseCase: UserUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
        self.userUserCase = userUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()

        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(model)
            .bind(to: output.model)
            .disposed(by: disposeBag)
        
        input.myAnswerObserver
            .asObservable()
            .map { $0 == MyAnswerViewNameSpace.answerInputViewPlaceholder ? false : $0.count > 0 ? true : false }
            .bind(to: output.isActiveAnswerCompletedButton)
            .disposed(by: disposeBag)
        
        input.tapPressForAnswerButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.userUserCase.getPartnerInfo()
                    .map { $0.nickname }
                    .bind(to: output.popUpPressForAnswerToastMessage)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
            
        input.tapAnswerCompletedButton
            .asObservable()
            .map { CustomAlertType.sendAnswer }
            .bind(to: output.popUpAlertObserver)
            .disposed(by: disposeBag)
        
        input.tapPopButton
            .asObservable()
            .withLatestFrom(model)
            .map { $0.isMyAnswer }
            .withLatestFrom(input.myAnswerObserver) { (isMyAnswer: $0, myAnswerStr: $1) }
            .map { event in
                event.isMyAnswer ? false :
                event.myAnswerStr == MyAnswerViewNameSpace.answerInputViewPlaceholder ? false :
                event.myAnswerStr.count > 0 ? true : false
            }.withUnretained(self)
            .bind { vm, event in
                if event {
                    output.popUpAlertObserver.accept(.popAnswer)
                } else {
                    output.bottomSheetHiddenObserver.accept(())
                }
            }.disposed(by: disposeBag)
        
        input.tapAlertRightButton
            .filter { $0 == .popAnswer }
            .map { _ in () }
            .bind(to: output.bottomSheetHiddenObserver)
            .disposed(by: disposeBag)
        
        input.tapAlertRightButton
            .filter { $0 == .sendAnswer }
            .withLatestFrom(input.myAnswerObserver)
            .withLatestFrom(model) { (index: $1.index, myAnswer: $0) }
            .withUnretained(self)
            .bind { vm, event in
                vm.questionUseCase.answerQuestion(entity: Answer(index: event.index, myAnswer: event.myAnswer))
                    .filter { $0 }
                    .bind { _ in
                        output.bottomSheetHiddenObserver.accept(())
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                            vm.coordinator?.finish()
                        }
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        output.bottomSheetHiddenObserver
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)

        return output
    }
}
