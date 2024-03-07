//
//  LockNumberFindViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/02/15.
//

import Foundation
import RxSwift
import RxCocoa

final class LockNumberFindViewModel {
    private weak var coordinator: LockNumberFindCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let partnerRequestButtonTapObserver: ControlEvent<Void>
        let sendEmailButtonTapObserver: ControlEvent<Void>
        let hiddenReasonObserver: PublishRelay<LockNumberFindViewHiddenReasonType>
    }
    
    init(coordinator: LockNumberFindCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) {
        
        // hind() 애니매이션 끝날때까지 지연
        input.hiddenReasonObserver
            .asObservable()
            .delay(RxTimeInterval.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { vm, reason in
                switch reason {
                case .dismissButton, .dimmedView:
                    vm.coordinator?.dismiss()
                case .partnerRequestButton:
                    vm.coordinator?.finish()
                }
            }.disposed(by: disposeBag)
    }
}
