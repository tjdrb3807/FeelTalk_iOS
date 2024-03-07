//
//  LockNumberInitRequestViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/16.
//

import Foundation
import RxSwift
import RxCocoa

final class LockNumberInitRequestViewModel {
    private weak var coordinator: LockNumberInitRequestCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let dismissButtonTapObserver: ControlEvent<Void>
        let requestButtonTapObserver: ControlEvent<Void>
    }
    
    init(coordinator: LockNumberInitRequestCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) {
        input.dismissButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
    }
}
