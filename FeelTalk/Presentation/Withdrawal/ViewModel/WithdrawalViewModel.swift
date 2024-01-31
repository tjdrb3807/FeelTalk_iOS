//
//  WithdrawalViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/30.
//

import Foundation
import RxSwift
import RxCocoa

final class WithdrawalViewModel {
    private weak var coordinator: WithdrawalCoordiantor?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let dismissButtonTapObserver: ControlEvent<Void>
        let withdrawalButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let terminationStatementType = PublishRelay<TerminationType>()
    }
    
    init(coordinator: WithdrawalCoordiantor) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .take(1)
            .asObservable()
            .withUnretained(self)
            .map { vm, _ -> TerminationType in .withdrawal }
            .bind(to: output.terminationStatementType)
            .disposed(by: disposeBag)
        
        input.withdrawalButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showWithdrawalDetailFlow()
            }.disposed(by: disposeBag)
        
        // NavigationController dismiss
        input.dismissButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return output
    }
}
