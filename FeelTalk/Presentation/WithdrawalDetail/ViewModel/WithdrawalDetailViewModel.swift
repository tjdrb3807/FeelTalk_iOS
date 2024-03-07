//
//  WithdrawalDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard

final class WithdrawalDetailViewModel {
    private weak var coordinator: WithdrawalDetailCoordinator?
    private let disposeBag = DisposeBag()
    
    private let itemTypes = BehaviorRelay<[WithdrawalReasonsType]>(value: [.breakUp, .noFunction, .bugOrError, .etc])
    private let selectedReasonObserver = PublishRelay<WithdrawalReasonsType>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let cellTapObserver: Observable<WithdrawalReasonsType>
        let popButtonTapObserver: ControlEvent<Void>
        let withdrawalButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let items = PublishRelay<[WithdrawalReasonsType]>()
        let selectedCell = PublishRelay<WithdrawalReasonsType>()
        let withdrawalButtonState = PublishRelay<Bool>()
        let popUpAlert = PublishRelay<CustomAlertType>()
        let keyboardHeight = PublishRelay<CGFloat>()
    }
    
    init(coordinator: WithdrawalDetailCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(itemTypes)
            .bind(to: output.items)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .asObservable()
            .map { _ -> WithdrawalReasonsType in .none }
            .bind(to: selectedReasonObserver)
            .disposed(by: disposeBag)
        
        input.cellTapObserver
            .bind(to: selectedReasonObserver)
            .disposed(by: disposeBag)
        
        // NavigationController pop
        input.popButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        input.withdrawalButtonTapObserver
            .asObservable()
            .map { _ -> CustomAlertType in .withdrawal }
            .bind(to: output.popUpAlert)
            .disposed(by: disposeBag)
        
        selectedReasonObserver
            .map { type -> Bool in type != .none ? true : false }
            .bind(to: output.withdrawalButtonState)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .filter { 0.0 <= $0 }
            .bind(to: output.keyboardHeight)
            .disposed(by: disposeBag)
        
        
        return output
    }
}
