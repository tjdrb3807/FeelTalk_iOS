//
//  WithdrawalDetailViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/08.
//

import Foundation
import RxSwift
import RxCocoa

final class WithdrawalDetailViewModel {
    private weak var coordinator: WithdrawalDetailCoordinator?
    private let disposeBag = DisposeBag()
    
    private let itemTypes = BehaviorRelay<[WithdrawalReasonsType]>(value: [.breakUp, .noFunction, .bugOrError, .etc])
    private let selectedReasonObserver = BehaviorRelay<WithdrawalReasonsType>(value: .none)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let cellTapObserver: Observable<WithdrawalReasonsType>
        let popButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let items = PublishRelay<[WithdrawalReasonsType]>()
        let selectedCell = PublishRelay<WithdrawalReasonsType>()
        let withdrawalButtonState = PublishRelay<Bool>()
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
        
        selectedReasonObserver
            .map { type -> Bool in type == .none ? false : true }
            .bind(to: output.withdrawalButtonState)
            .disposed(by: disposeBag)
        
        
        return output
    }
}
