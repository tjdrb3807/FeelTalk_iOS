//
//  InviteCodeViewModel.swift
//  FeelTalk
//
//  Created by 전성규 on 2023/07/19.
//

import Foundation
import RxSwift
import RxCocoa

final class InviteCodeViewModel {
    private weak var coordinator: InviteCodeCoordinator?
    private let userUseCase: UserUseCase
    private let disposBag = DisposeBag()
    let fcmHandeler = FCMHandler.shared
    
    struct Input {
        let viewDidLoad: ControlEvent<Bool>
        let tapPresentBottomSheetViewButton: ControlEvent<Void>
    }
    
    struct Output {
        let inviteCode: PublishRelay<String> = PublishRelay<String>()
    }
    
    init(coordinator: InviteCodeCoordinator, userUseCase: UserUseCase) {
        self.coordinator = coordinator
        self.userUseCase = userUseCase
    }
    
    func transfer(input: Input) -> Output {
        let output = Output()
        
        fcmHandeler.createCoupleObservable
            .withUnretained(self)
            .bind { vm, state in
                if state {
                    KeychainRepository.addItem(value: UserState.couple.rawValue, key: "userState")
                    vm.coordinator?.finish()
                }
            }.disposed(by: disposBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .bind { vm, _ in
                vm.userUseCase.getInviteCode()
                    .bind(to: output.inviteCode)
                    .disposed(by: vm.disposBag)
            }.disposed(by: disposBag)
        
        input.tapPresentBottomSheetViewButton
            .withUnretained(self)
            .bind { vm, _ in
                vm.coordinator?.showInviteCodeBottomSheetCoordinator()
            }.disposed(by: disposBag)
        
        return output
    }
}


