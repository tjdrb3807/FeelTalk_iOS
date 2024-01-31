//
//  BreakUpViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/05.
//

import Foundation
import RxSwift
import RxCocoa

final class BreakUpViewModel {
    weak var coordinator: BreakUpCoordinator?
    private var configurationUseCase: ConfigurationUseCase
    private let disposeBag = DisposeBag()
    
    let questionCount = PublishRelay<Int>()
    let challengeCount = PublishRelay<Int>()
    let terminationType = BehaviorRelay<TerminationType>(value: .breakUp)
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let navigationBarLeftButtonTapObserver: ControlEvent<Void>
    }
    
    struct Output {
        let questionCount: PublishRelay<Int>
        let challengeCount: PublishRelay<Int>
        let terminationType: BehaviorRelay<TerminationType>
    }
    
    init(coordinator: BreakUpCoordinator, configurationUseCase: ConfigurationUseCase) {
        self.coordinator = coordinator
        self.configurationUseCase = configurationUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withUnretained(self)
            .bind { vm, _ in
                vm.configurationUseCase.getServiceDataTotalCount()
                    .bind(onNext: { model in
                        vm.questionCount.accept(model.questionCount)
                        vm.challengeCount.accept(model.challengeCount)
                    }).disposed(by: vm.disposeBag)
                vm.terminationType.accept(.breakUp)
            }.disposed(by: disposeBag)
        
        input.navigationBarLeftButtonTapObserver
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return Output(questionCount: self.questionCount,
                      challengeCount: self.challengeCount,
                      terminationType: self.terminationType)
    }
}
