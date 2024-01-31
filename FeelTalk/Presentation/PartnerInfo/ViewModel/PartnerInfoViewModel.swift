//
//  PartnerInfoViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation
import RxSwift
import RxCocoa

final class PartnerInfoViewModel {
    weak var coodinator: PartnerInfoCoordinator?
    private let userUseCase: UserUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearObserver: ControlEvent<Bool>
        let viewDidDisappearObserver: ControlEvent<Bool>
        let popButtonTapObserver: ControlEvent<Void>
        let breakButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let partnerModel = PublishRelay<PartnerInfo>()
    }
    
    init(coordinator: PartnerInfoCoordinator, userUseCase: UserUseCase) {
        self.coodinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        // Set partner information
        input.viewWillAppearObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.userUseCase.getPartnerInfo()
                    .bind(to: output.partnerModel)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        // Present breakVC
        input.breakButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coodinator?.showBreakUpFlow()
            }.disposed(by: disposeBag)
        
        // Pop navigation
        Observable
            .merge(input.viewDidDisappearObserver.asObservable().map { _ in () },
                   input.popButtonTapObserver.asObservable())
            .withUnretained(self)
            .bind { vm, _ in
                vm.coodinator?.finish()
            }.disposed(by: disposeBag)
        
        return output
    }
}
