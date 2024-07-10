//
//  SignalViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class SignalViewModel {
    private weak var coordinator: SignalCoordinator?
    private let signalUseCase: SignalUseCase
    private let disposeBag = DisposeBag()
    
    private let model = PublishRelay<Signal>()
    private let selectedSignal = PublishRelay<Signal>()
//    private let selectedSignal = PublishRelay<Signal>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let selectedSignal: Observable<Signal>
        let tapChangeSignalButton: ControlEvent<Void>
        let dismiss: Observable<Void>
        let tapChatRoomButton: ControlEvent<Void>
    }
    
    struct Output {
        let selectedSignal: PublishRelay<Signal>
    }
    
    init(coordinator: SignalCoordinator, signalUseCase: SignalUseCase) {
        self.coordinator = coordinator
        self.signalUseCase = signalUseCase
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.signalUseCase.getMySignal()
                    .bind(to: vm.model)
                    .disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.selectedSignal
            .bind(to: model)
            .disposed(by: disposeBag)
        
        input.tapChangeSignalButton
            .withLatestFrom(model)
            .withUnretained(self)
            .bind { vm, model in
                vm.signalUseCase.changeMySignal(model)
                    .filter { $0 }
                    .delay(.microseconds(300), scheduler: MainScheduler.instance)
                    .bind(onNext: { _ in
                        vm.coordinator?.finish()
                    }).disposed(by: vm.disposeBag)
            }.disposed(by: disposeBag)
        
        input.dismiss
            .delay(.milliseconds(300),
                   scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        input.tapChatRoomButton
            .asObservable()
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismissAndShowChatFlow()
            }.disposed(by: disposeBag)
        
        return Output(selectedSignal: self.model)
    }
}
