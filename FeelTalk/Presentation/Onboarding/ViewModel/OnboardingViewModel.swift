//
//  OnboardingViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2024/01/01.
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingViewModel {
    private weak var coordinator: OnboardingCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
        let tapStartButton: Observable<Void>
        let tapInquiryButton: Observable<Void>
    }
    
    struct Output { }
    
    init(coordinator: OnboardingCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        input.tapStartButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        input.tapInquiryButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showInquiryFlow()
            }.disposed(by: disposeBag)
        
        return output
    }
}
