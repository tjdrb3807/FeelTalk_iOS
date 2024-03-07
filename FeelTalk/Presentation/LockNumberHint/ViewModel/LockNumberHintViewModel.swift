//
//  LockNumberHintViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/05.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class LockNumberHintViewModel {
    private weak var coordinator: LockNumberHintCoordinator?
    private let configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    let viewType = ReplayRelay<LockNumberHintViewType>.create(bufferSize: 1)
    let initPW = ReplayRelay<String?>.create(bufferSize: 1)
    let textAnswer = BehaviorRelay<String>(value: "")
    let dateAnswer = BehaviorRelay<String>(value: Date.dateToStr(Date()))
    
    private let selectedHint = PublishRelay<LockNumberHintType>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let hintPickerCellTabObserver: ControlEvent<LockNumberHintType>
        let textAnswerObserver: Observable<String>
        let dateAnswerObserver: Observable<Date>
        let confirmButtonTapObserver: ControlEvent<Void>
        let popButtonTapObserver: ControlEvent<Void>
        let helpButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let keyboardHeight = BehaviorRelay<CGFloat>(value: 0.0)
        let viewTypeObserber = PublishRelay<LockNumberHintViewType>()
        let selectedHint = PublishRelay<LockNumberHintType>()
        let confirmButtonState = BehaviorRelay<Bool>(value: false)
    }
    
    init(coordinator: LockNumberHintCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { $0 >= 0.0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
    
        selectedHint
            .bind(to: output.selectedHint)
            .disposed(by: disposeBag)
        
        // TextAnswer 입력 상태에 따른 confirmButton 활성화 여부
        textAnswer
            .skip(1)
            .bind { text in
                text.isEmpty ? output.confirmButtonState.accept(false) : output.confirmButtonState.accept(true)
            }.disposed(by: disposeBag)
        
        // DateAnswer 입력 상태에 따른 confirmButton 활성화 여부
        dateAnswer
            .skip(1)
            .bind { _ in
                output.confirmButtonState.accept(true)
            }.disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(viewType)
            .withUnretained(self)
            .bind { vm, type in
                output.viewTypeObserber.accept(type)
                if type == .settings {
                    vm.selectedHint.accept(.treasure)
                } else {
                    vm.configurationUseCase
                        .getLockNumberHintType()
                        .asObservable()
                        .bind(to: output.selectedHint)
                        .disposed(by: vm.disposeBag)
                }
            }.disposed(by: disposeBag)
        
        input.hintPickerCellTabObserver
            .bind(to: selectedHint)
            .disposed(by: disposeBag)
        
        input.textAnswerObserver
            .bind(to: textAnswer)
            .disposed(by: disposeBag)
        
        input.dateAnswerObserver
            .map { date -> String in Date.dateToStr(date) }
            .bind(to: dateAnswer)
            .disposed(by: disposeBag)
        
        input.confirmButtonTapObserver
            .asObservable()
            .withLatestFrom(viewType)
            .filter { $0 == .settings }
            .withLatestFrom(initPW)
            .withLatestFrom(selectedHint) { (password: $0, hintType: $1) }
            .withUnretained(self)
            .bind { vm, event in
                var lockNumberSettings: LockNumberSettings
                switch event.hintType {
                case .date:
                    lockNumberSettings = LockNumberSettings(
                        lockNumber: event.password!,
                        hintType: event.hintType,
                        correctAnswer: vm.dateAnswer.value)
                default:
                    lockNumberSettings = LockNumberSettings(
                        lockNumber: event.password!,
                        hintType: event.hintType,
                        correctAnswer: vm.textAnswer.value)
                }
                
                vm.configurationUseCase.setLockNumber(lockNumberSettings)
                    .filter { $0 }
                    .bind { _ in
                        DefaultAppCoordinator.isLockScreenObserver.accept(true)
                        vm.coordinator?.finish()
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.helpButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showLockNumberFindFlow()
            }.disposed(by: disposeBag)
            
        input.popButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.pop()
            }.disposed(by: disposeBag)

        return output
    }
}
