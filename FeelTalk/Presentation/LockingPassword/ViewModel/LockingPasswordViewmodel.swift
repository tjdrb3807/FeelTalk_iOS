//
//  LockingPasswordViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/09/20.
//

import Foundation
import RxSwift
import RxCocoa

final class LockingPasswordViewModel {
    private weak var coordinator: LockingPasswordCoordinator?
    let viewMode = ReplayRelay<LockingPasswordViewMode>.create(bufferSize: 1)
    private let disposeBag = DisposeBag()
    
    private let dataList = [LockingPasswordKeypadModel(title: "1"),
                            LockingPasswordKeypadModel(title: "4"),
                            LockingPasswordKeypadModel(title: "7"),
                            LockingPasswordKeypadModel(title: "취소"),
                            LockingPasswordKeypadModel(title: "2"),
                            LockingPasswordKeypadModel(title: "5"),
                            LockingPasswordKeypadModel(title: "8"),
                            LockingPasswordKeypadModel(title: "0"),
                            LockingPasswordKeypadModel(title: "3"),
                            LockingPasswordKeypadModel(title: "6"),
                            LockingPasswordKeypadModel(title: "9"),
                            LockingPasswordKeypadModel(title: "확인")]
    private let mode = PublishRelay<LockingPasswordViewMode>()
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapKeypad: ControlEvent<LockingPasswordKeypadModel>
    }
    
    struct Output {
        let modelList: Driver<[LockingPasswordKeypadModel]>
        let mode: PublishRelay<LockingPasswordViewMode>
    }
    
    init(coordinator: LockingPasswordCoordinator) {
        self.coordinator = coordinator
    }
    
    func transfer(input: Input) -> Output {
        input.viewWillAppear
            .withLatestFrom(viewMode)
            .withUnretained(self)
            .bind { vm, mode in
                vm.mode.accept(mode)
            }.disposed(by: disposeBag)
        
        input.tapKeypad
            .filter { $0.title != "확인" && $0.title != "취소" }
            .map { $0.title }
            .withUnretained(self)
            .bind { vm, numberString in
                print(numberString)
            }.disposed(by: disposeBag)
        
        input.tapKeypad
            .filter { $0.title == "확인" }
            .withUnretained(self)
            .bind { vm, _ in
                print("확인 누름")
            }.disposed(by: disposeBag)
        
        input.tapKeypad
            .filter { $0.title == "취소" }
            .withUnretained(self)
            .bind { vm, _ in
                print("취소 누름")
                vm.coordinator?.finish()
            }.disposed(by: disposeBag)
            
        
        return Output(modelList: Driver.just(dataList),
                      mode: self.mode)
    }
}
