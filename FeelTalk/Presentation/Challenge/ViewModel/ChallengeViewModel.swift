//
//  ChallengeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/08/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ChallengeViewModel {
    private weak var coordinator: ChallengeCoordinator?
    private let challengeUseCase: ChallengeUseCase
    private let disposeBag = DisposeBag()
    
    private let challengeCount = PublishRelay<ChallengeCount>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapRegisterButton: ControlEvent<Void>
    }
    
    struct Output {
        let challengeCount: PublishRelay<ChallengeCount>
    }
    
    init(coordinator: ChallengeCoordinator, challengeUseCase: ChallengeUseCase) {
        self.coordinator = coordinator
        self.challengeUseCase = challengeUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.challengeUseCase.getChallengeCount()
                    .bind { count in
                        vm.challengeCount.accept(count)
                    }.disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.tapRegisterButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showChallengeDetailFlow()
                vm.coordinator?.challengeModel.accept(Challenge())
            }.disposed(by: disposeBag)
        
        return Output(challengeCount: self.challengeCount)
    }
}
