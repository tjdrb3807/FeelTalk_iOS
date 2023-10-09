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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidDisappear: ControlEvent<Bool>
        let tapPopButton: ControlEvent<Void>
        let tapBreakUpButton: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    init(coordinator: PartnerInfoCoordinator) {
        self.coodinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        Observable
            .merge(input.tapPopButton.asObservable(),
                   input.viewDidDisappear.map { _ in () })
            .withUnretained(self)
            .bind { vm, _ in
                vm.coodinator?.finish()
            }.disposed(by: disposeBag)
        
        input.tapBreakUpButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coodinator?.showBreakUpFlow()
            }.disposed(by: disposeBag)
        
        return Output()
    }
}
