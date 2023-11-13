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
    private let disposeBag = DisposeBag()
    
    /// HomeVC에서 선택퇸 Signal
    let model = ReplayRelay<Signal>.create(bufferSize: 1)
    /// SignalVC에서 선택된 Signal
    private let selectedSignal = PublishRelay<Signal>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let selectedSignal: Observable<Signal>
        let tapChangeSignalButton: ControlEvent<Void>
        let dismiss: Observable<Void>
    }
    
    struct Output {
        let selectedSignal: PublishRelay<Signal>
    }
    
    init(coordinator: SignalCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(model)
            .bind(to: selectedSignal)
            .disposed(by: disposeBag)
        
        input.selectedSignal
            .bind(to: selectedSignal)
            .disposed(by: disposeBag)
        
        input.tapChangeSignalButton
            .withLatestFrom(selectedSignal)
            .withUnretained(self)
            .delay(.milliseconds(300),
                   scheduler: MainScheduler.instance)
            .bind { vm, signal in
                vm.coordinator?.signalModel.accept(signal)
//                vm.model.accept(signal)
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
        
        input.dismiss
            .delay(.milliseconds(300),
                   scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.dismiss()
            }.disposed(by: disposeBag)
        
        return Output(selectedSignal: self.selectedSignal)
    }
}
