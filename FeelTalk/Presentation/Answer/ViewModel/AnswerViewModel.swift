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
        let tapChatRoomButton: ControlEvent<Void>
    }
    
    struct Output {
        let model: Driver<Question>
        let keyboardHeight: Driver<CGFloat>
        let isActiveAnswerCompletedButton: Driver<Bool>
        
        let bottomSheetHidden: RxCocoa.Signal<Void>
        let popUpAlert: RxCocoa.Signal<CustomAlertType>
        let popUpPressForAnswerToastMessage: RxCocoa.Signal<String>
    }
    
    init(coordinator: AnswerCoordinator, questionUseCase: QuestionUseCase, userUseCase: UserUseCase) {
        self.coordinator = coordinator
        self.questionUseCase = questionUseCase
        self.userUserCase = userUseCase
    }
    
    func transform(input: Input) -> Output {
        let modelRelay = PublishRelay<Question>()
        let keyboardHeightRelay = BehaviorRelay<CGFloat>(value: 0.0)
        let isActiveButtonRelay = BehaviorRelay<Bool>(value: false)
        
        let bottomSheetHiddenRelay = PublishRelay<Void>()
        let popUpAlertRelay = PublishRelay<CustomAlertType>()
        let toastMessageRelay = PublishRelay<String>()

        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0 <= $0 }
            .bind(to: keyboardHeightRelay)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(model)
            .bind(to: modelRelay)
            .disposed(by: disposeBag)
        
        input.myAnswerObserver
            .asObservable()
            .map { $0 == MyAnswerViewNameSpace.answerInputViewPlaceholder ? false : $0.count > 0 ? true : false }
            .bind(to: isActiveButtonRelay)
            .disposed(by: disposeBag)
        
        input.tapPressForAnswerButton
            .asObservable()
            .withLatestFrom(model)
            .withUnretained(self)
            .bind { vm, question in
                vm.questionUseCase.pressForAnswer(index: question.index)
                    .asObservable()
                    .bind(to: toastMessageRelay)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
            
        input.tapAnswerCompletedButton
            .asObservable()
            .map { CustomAlertType.sendAnswer }
            .bind(to: popUpAlertRelay)
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
                    popUpAlertRelay.accept(.popAnswer)
                } else {
                    bottomSheetHiddenRelay.accept(())
                }
            }.disposed(by: disposeBag)
        
        input.tapAlertRightButton
            .filter { $0 == .popAnswer }
            .map { _ in () }
            .bind(to: bottomSheetHiddenRelay)
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
                        bottomSheetHiddenRelay.accept(())
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(500)) {
                            vm.coordinator?.finish()
                        }
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        bottomSheetHiddenRelay
            .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        input.tapChatRoomButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismissAndShowChatFlow()
            }.disposed(by: disposeBag)
        
        return Output(
            model: modelRelay.asDriver(onErrorDriveWith: .empty()),
            keyboardHeight: keyboardHeightRelay.asDriver(onErrorJustReturn: 0.0),
            isActiveAnswerCompletedButton: isActiveButtonRelay.asDriver(onErrorJustReturn: false),
            bottomSheetHidden: bottomSheetHiddenRelay.asSignal(),
            popUpAlert: popUpAlertRelay.asSignal(),
            popUpPressForAnswerToastMessage: toastMessageRelay.asSignal())
    }
}
