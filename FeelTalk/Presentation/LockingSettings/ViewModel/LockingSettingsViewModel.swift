//
//  LockingSettingsViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa

final class LockingSettingsViewModel {
    private weak var coodinator: LockingSettingsCoordinator?
    private let disposeBag = DisposeBag()
    
    let isLockScreen = ReplayRelay<Bool>.create(bufferSize: 1)
    let cellData = PublishRelay<[LockingSettingsModel]>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapCell: ControlEvent<LockingSettingsModel>
//        let tapSwitchButton: PublishRelay<Void>
    }
    
    struct Output {
        let cellData: Driver<[LockingSettingsModel]>
    }
    
    init(coordinator: LockingSettingsCoordinator) {
        self.coodinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withLatestFrom(isLockScreen)
            .withUnretained(self)
            .bind { vm, state in
                vm.setData(with: state)
            }.disposed(by: disposeBag)
        
        cellData
            .bind(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    
        input.tapCell
            .filter { $0.type == .lockTheScreen }
            .map { !$0.state! }
            .withUnretained(self)
            .bind { vm, state in
                vm.setData(with: state)
            }.disposed(by: disposeBag)
        
        input.tapCell
            .filter { $0.type == .lockTheScreen }
            .filter { $0.state! }
            .withUnretained(self)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)  // TODO: Delay 시간 조정
            .bind { vm, _ in
                vm.coodinator?.showLockingPasswordFlow()
                vm.coodinator?.lockingPasswordViewMode.accept(.settings)
            }.disposed(by: disposeBag)
        
        return Output(cellData: self.cellData.asDriver(onErrorJustReturn: []))
    }
}

extension LockingSettingsViewModel {
    private func setData(with state: Bool) {
        state ?
        cellData.accept([LockingSettingsModel(type: .lockTheScreen, state: state), LockingSettingsModel(type: .changePassword)]) :
        cellData.accept([LockingSettingsModel(type: .lockTheScreen, state: state)])
    }
}
